class ShopsController < ApplicationController
  before_action :set_shop, only: %i[ show edit update destroy ]
  before_action :authenticate, only: [:update, :destroy]
  before_action :show_authenticate, only: [:show]

  def authenticate
    redirect_to login_accounts_url, alert: "Must be seller | admin!" unless current_admin? ||
      (current_seller? && current_account.seller.shops.exists? { |s| s == @shop })
  end

  def show_authenticate
    redirect_to login_accounts_url, alert: "Must be this shop's owner" unless current_seller? &&
      current_account.seller.shops.exists? { |s| s == @shop }
  end

  # GET /shops or /shops.json
  def index
    @shops = Shop.all
  end

  # GET /shops/1 or /shops/1.json
  def show
  end

  # GET /shops/new
  def new
    @shop = Shop.new
  end

  # GET /shops/1/edit
  def edit
  end

  # POST /shops or /shops.json
  def create
    @seller = Seller.find(params[:seller_id])
    @shop = Shop.new(shop_params)
    @shop.seller = @seller

    respond_to do |format|
      if @shop.save
        format.html { redirect_to @seller, notice: "成功创建店铺！" }
        format.json { render :show, status: :created, location: @shop }
      else
        format.html { render "sellers/show", status: :unprocessable_entity }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shops/1 or /shops/1.json
  def update
    respond_to do |format|
      @seller = Seller.find(params[:seller_id])
      if @shop.update(shop_params)
        format.html { redirect_to @seller, notice: "成功更新店铺！" }
        format.json { render :show, status: :ok, location: @shop }
      else
        format.html { render "sellers/show", status: :unprocessable_entity }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shops/1 or /shops/1.json
  def destroy
    @shop.destroy
    respond_to do |format|
      format.html { redirect_to seller_url(Seller.find(@shop.seller_id)), notice: "成功删除店铺！" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shop
      @shop = Shop.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shop_params
      params.require(:shop).permit(:name, :introduction, :seller_id)
    end
end
