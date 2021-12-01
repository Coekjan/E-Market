class CommoditiesController < ApplicationController
  before_action :set_commodity, only: %i[ show edit update destroy ]

  # GET /commodities or /commodities.json
  def index
    @commodities = Commodity.all
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
        format.html { redirect_to seller_shop_url(@commodity.shop.seller, @commodity.shop),
                                  notice: "Commodity was successfully created." }
        format.json { render :show, status: :created, location: @commodity }
      else
        format.html { render seller_shop_url(@commodity.shop.seller, @commodity.shop), status: :unprocessable_entity }
        format.json { render json: @commodity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /commodities/1 or /commodities/1.json
  def update
    respond_to do |format|
      if @commodity.update(commodity_params)
        format.html { redirect_to seller_shop_url(@commodity.shop.seller, @commodity.shop),
                                  notice: "Commodity was successfully updated." }
        format.json { render :show, status: :ok, location: @commodity }
      else
        format.html { render seller_shop_url(@commodity.shop.seller, @commodity.shop), status: :unprocessable_entity }
        format.json { render json: @commodity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /commodities/1 or /commodities/1.json
  def destroy
    @commodity.destroy
    respond_to do |format|
      format.html { redirect_to seller_shop_url(@commodity.shop.seller, @commodity.shop), notice: "Commodity was successfully destroyed." }
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
      params.require(:commodity).permit(:name, :introduction, :price, :shop_id, :category_ids)
    end
end
