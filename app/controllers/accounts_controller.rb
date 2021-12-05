class AccountsController < ApplicationController
  before_action :set_account, only: %i[ show edit update destroy ]

  def login
  end

  def do_login
    account = Account.where(id: params[:id], name: params[:name], password: params[:password]).first
    if account
      session[:current_account_id] = account.id
      redirect_to commodities_url, notice: "Account Login Successfully."
    else
      redirect_to login_accounts_url, alert: "Wrong account name or password!"
    end
  end

  def logout
    session.delete(:current_account_id)
    redirect_to login_accounts_url, alert: "Account logout successfully!"
  end

  # GET /accounts or /accounts.json
  def index
    @accounts = Account.all
  end

  # GET /accounts/1 or /accounts/1.json
  def show
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts or /accounts.json
  def create
    @account = Account.new(account_params)
    role = Role.find(@account.role_id).role_type
    check_role = /^(Admin|Seller|Customer)$/ === role

    respond_to do |format|
      if @account.save && check_role
        if role == "Admin"
          admin = Admin.new
          admin.account_id = @account.id
          admin.save
        elsif role == "Seller"
          seller = Seller.new
          seller.account_id = @account.id
          seller.save
        else role == "Customer"
          customer = Customer.new
          customer.account_id = @account.id
          customer.save
        end
        format.html { redirect_to @account, notice: "Account was successfully created." }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1 or /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: "Account was successfully updated." }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1 or /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: "Account was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def account_params
      params.require(:account).permit(:name, :password, :role_id, :balance)
    end
end
