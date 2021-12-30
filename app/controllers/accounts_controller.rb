class AccountsController < ApplicationController
  before_action :set_account, only: %i[ show edit update destroy ]
  before_action :set_account_for_top_up, only: [:top_up, :do_top_up]
  before_action :authenticate, except: [:statistic, :login, :do_login, :logout, :register, :do_register, :top_up, :do_top_up]
  before_action :authenticate_top_up, only: [:top_up, :do_top_up]
  before_action :authenticate_statistic, only: [:statistic]

  def authenticate
    redirect_to login_accounts_url, alert: "Must Be ADMIN && Login!" unless current_admin?
  end

  def authenticate_top_up
    redirect_to root_url, alert: "Illegal Behavior!" unless current_account &&
      current_account.id == params[:account_id].to_i
  end

  def authenticate_statistic
    redirect_to root_url, alert: "Illegal Behavior!" unless current_admin? || current_seller?
  end

  def statistic
  end

  def login
  end

  def do_login
    account = Account.where(id: params[:id], password: params[:password]).first
    if account
      session[:current_account_id] = account.id
      redirect_to commodities_url, alert: {id: "用户登录成功！", type: "alert alert-success", role: 'alert'}
    else
      redirect_to login_accounts_url, alert: {id: "账户错误或密码错误！", type: "alert alert-danger", role: 'alert'}
    end
  end

  def logout
    session.delete(:current_account_id)
    redirect_to login_accounts_url, alert: {id: "用户注销成功！", type: "alert alert-success", role: 'alert'}
  end

  def register
  end

  def do_register
    name, role, password = params.require([:name, :role, :password])
    @account = Account.new({ name: name, role: role, password: password })
    check_role = /^(Seller|Customer)$/ === @account.role
    if check_role && @account.save
      t = eval(@account.role).new
      t.account_id = @account.id
      @account.update_attribute(:balance, 0)
      t.save
      redirect_to login_accounts_url, alert: {id: "用户注册成功！你的账户ID是" + @account.id.to_s + ".请记住您的ID用于登录", type: "alert alert-success", role: 'alert'}
    else
      redirect_to register_accounts_url, {id: "创建用户失败！", type: "alert alert-danger", role: 'alert'}
    end
  end

  def top_up
  end

  def do_top_up
    delta = top_up_account_params.to_i
    respond_to do |format|
      if delta > 0
        @account.update_attribute(:balance, @account.balance + delta)
        format.html { redirect_to account_top_up_url(@account), alert: {id: "充值成功！", type: "alert alert-success", role: 'alert'} }
        format.json { render :top_up, status: :created, location: account_top_up_url(@account) }
      else
        format.html { render account_top_up_url(@account), alert: { id: "非法充值！", type: "alert alert-danger", role: 'alert' } }
        format.json { render :top_up, status: :unprocessable_entity }
      end
    end
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
    role = @account.role
    check_role = /^(Admin|Seller|Customer)$/ === role

    respond_to do |format|
      if check_role && @account.save
        @account.update_attribute(:balance, 0)
        t = eval(role).new
        t.account_id = @account.id
        t.save
        format.html { redirect_to @account, notice: "账户创建成功！" }
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
      if @account.update(edit_account_params)
        format.html { redirect_to @account, notice: "用户信息更新成功！" }
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
      format.html { redirect_to accounts_url, notice: "用户账户成功删除！" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    def set_account_for_top_up
      @account = Account.find(params[:account_id])
    end

    # Only allow a list of trusted parameters through.
    def account_params
      params.require(:account).permit(:name, :password, :role)
    end

    def edit_account_params
      params.require(:account).permit(:name, :password)
    end

    def top_up_account_params
      params.require(:balance_add)
    end
end
