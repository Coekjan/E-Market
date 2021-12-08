class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]
  before_action :set_order_for_purchase, only: [:purchase]
  before_action :create_authenticate, only: [:create]
  before_action :edit_authenticate, only: [:edit, :update, :destroy]
  before_action :show_authenticate, only: [:show, :index]

  def create_authenticate
    redirect_to login_accounts_url, alert: "Illegal Behavior" unless current_customer? &&
      current_account.customer.id == params[:customer_id].to_i
  end

  def edit_authenticate
    redirect_to login_accounts_url, alert: "Illegal Behavior" unless current_customer? &&
      current_account.customer.id == @order.customer.id
  end

  def show_authenticate
    redirect_to login_accounts_url, alert: "Illegal Behavior" unless current_customer? &&
      current_account.customer == Customer.find(params[:customer_id])
  end

  # GET /orders or /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    @order = Order.new(create_order_params)
    if @order.count <= 0
      redirect_to commodity_url(@order.commodity), alert: "Illegal Count"
    end
    @commodity = Commodity.find(params[:order][:commodity_id])
    @order.price = @commodity.price * params[:order][:count].to_i
    respond_to do |format|
      if @order.save
        format.html { redirect_to customer_orders_url(@order.customer), notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render seller_shop_url(@commodity.shop.seller, @commodity.shop), status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update

    respond_to do |format|
      if @order.update(update_order_params)
        @order.update_attribute(:price, params[:order][:count].to_i * @order.commodity.price)
        format.html { redirect_to customer_order_url(@order.customer, @order), notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render edit_customer_order_url(@order.customer, @order), status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to customer_orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def purchase
    if @order.done
      redirect_to customer_order_url(@customer, @order), alert: "This order was done!"
    end
    @customer = @order.customer
    if @customer.account.balance >= @order.price
      @order.update_attribute(:done, true)
      @record = Record.new
      @record.order = @order
      @record.save
      @customer.account.update_attribute(:balance, @customer.account.balance - @order.price)
      @order.commodity.shop.seller.account
            .update_attribute(:balance, @order.commodity.shop.seller.account.balance + @order.price)
      redirect_to customer_order_url(@customer, @order), notice: "Successfully!"
    else
      redirect_to customer_order_url(@customer, @order), alert: "Balance not enough!"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    def set_order_for_purchase
      @order = Order.find(params[:order_id])
    end

    # Only allow a list of trusted parameters through.
    def create_order_params
      params.require(:order).permit(:count, :done, :commodity_id, :customer_id)
    end

    def update_order_params
      params.require(:order).permit(:count)
    end
end
