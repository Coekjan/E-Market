class CommoditiesController < ApplicationController
  before_action :set_commodity, only: %i[ show edit update destroy ]
  before_action :authenticate, except: [:do_filter, :index, :show]

  def authenticate
    redirect_to login_accounts_url, alert: 'Must Login as this commodity\'s owner!' unless current_account &&
      current_account.id == (params[:commodity] && params[:commodity][:shop_id] ?
                               Shop.find(params[:commodity][:shop_id]).seller.account.id :
                               @commodity.shop.seller.account.id)
  end

  def do_filter
    @commodities = Commodity.all
    @commodities = @commodities.filter_by_categories(params[:category_ids]) if params[:category_ids].present?
    flash[:commodity_filter] = @commodities
    flash[:filter_categories] = params[:category_ids].reject(&:blank?).map(&:to_i)
    redirect_to commodities_url
  end

  # GET /commodities or /commodities.json
  def index
    @temp_filter = flash[:commodity_filter]
    @temp_categories = flash[:filter_categories]
    flash.delete(:commodity_filter)
    flash.delete(:filter_categories)
    if @temp_filter
      print @temp_filter
      @commodities = @temp_filter.map { |c| Commodity.all.filter { |cc| cc.id == c["id"] }.first }
      print @commodities
    else
      @commodities = Commodity.all
    end
  end

  # GET /commodities/1 or /commodities/1.json
  def show
  end

  # GET /commodities/new
  def new
    @commodity = Commodity.new
  end

  # GET /commodities/1/edit
  def edit
  end

  # POST /commodities or /commodities.json
  def create
    @commodity = Commodity.new(commodity_params)
    respond_to do |format|
      if @commodity.save
        @commodity.image.attach(params[:commodity][:image])
        format.html { redirect_to @commodity, notice: "成功创建商品！" }
        format.json { render :show, status: :created, location: @commodity }
      else
        format.html { render "commodities/new", status: :unprocessable_entity }
        format.json { render json: @commodity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /commodities/1 or /commodities/1.json
  def update
    respond_to do |format|
      if @commodity.update(commodity_params)
        @commodity.image.attach(params[:commodity][:image])
        format.html { redirect_to @commodity, notice: "成功更新商品！" }
        format.json { render :show, status: :ok, location: @commodity }
      else
        format.html { render "commodities/edit", status: :unprocessable_entity }
        format.json { render json: @commodity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /commodities/1 or /commodities/1.json
  def destroy
    @commodity.destroy
    respond_to do |format|
      format.html { redirect_to seller_shop_url(@commodity.shop.seller, @commodity.shop), notice: "成功删除商品！" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_commodity
      @commodity = Commodity.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def commodity_params
      params.require(:commodity).permit(:name, :introduction, :price, :shop_id, :image, category_ids: [])
    end
end
