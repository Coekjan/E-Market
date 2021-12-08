class AdminsController < ApplicationController
  before_action :set_admin, only: %i[ show edit update destroy ]
  before_action :authenticate

  def authenticate
    redirect_to login_accounts_url, alert: "Must Be ADMIN && Login!" unless current_account &&
      current_account.role == "Admin"
  end

  # GET /admins or /admins.json
  def index
    @admins = Admin.all
  end

  # GET /admins/1 or /admins/1.json
  def show
  end

  # GET /admins/new
  def new
    @admin = Admin.new
  end

  # GET /admins/1/edit
  def edit
  end

  # POST /admins or /admins.json
  def create
    @admin = Admin.new(admin_params)

    respond_to do |format|
      if @admin.save
        Account.find(@admin.account_id).role = 'Admin'
        format.html { redirect_to @admin, notice: "Admin was successfully created." }
        format.json { render :show, status: :created, location: @admin }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admins/1 or /admins/1.json
  def update
    respond_to do |format|
      if @admin.update(admin_params)
        format.html { redirect_to @admin, notice: "Admin was successfully updated." }
        format.json { render :show, status: :ok, location: @admin }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admins/1 or /admins/1.json
  def destroy
    @admin.destroy
    respond_to do |format|
      format.html { redirect_to admins_url, notice: "Admin was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = Admin.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_params
      params.require(:admin).permit(:account_id)
    end
end
