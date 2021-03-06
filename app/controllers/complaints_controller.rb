class ComplaintsController < ApplicationController
  before_action :set_complaint, only: %i[ show edit update destroy authenticate_handle ]
  before_action :set_handle_complaint, only: %i[ handle do_handle ]
  before_action :authenticate_create, only: [:new, :edit, :create, :update]
  before_action :authenticate_show, only: [:show, :edit, :update]
  before_action :authenticate_handle, only: [:do_handle, :handle]
  before_action :authenticate_check_not_handled, only: [:handle, :do_handle, :edit, :destroy, :update]
  before_action :authenticate_destroy, only: [:destroy]

  def authenticate_create
    redirect_to login_accounts_url, alert: "Must login as customer" unless current_customer?
  end

  def authenticate_show
    redirect_to login_accounts_url, alert: "You have no permission to visit this page" unless current_admin? || (
      current_customer? && current_account.customer == @complaint.customer
    ) || (
      current_seller? && current_account.seller == @complaint.seller
    )
  end

  def authenticate_handle
    redirect_to login_accounts_url, alert: "Must login as ADMIN" unless current_admin?
    index
  end

  def authenticate_check_not_handled
    redirect_to complaints_url, status: :not_acceptable if @complaint.is_handled?
  end

  def authenticate_destroy
    redirect_to complaints_url, status: :not_acceptable unless current_admin? || (
      current_customer? && current_account.customer == @complaint.customer
    )
  end

  def handle
  end

  def do_handle
    respond_to do |format|
      if @complaint.update(complaint_handle_params)
        format.html { redirect_to complaints_url, notice: "成功处理投诉！" }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @complaint.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /complaints or /complaints.json
  def index
    if current_admin?
      @complaints = Complaint.all
    elsif current_seller?
      @complaints = Complaint.all.filter { |c| c.seller == current_account.seller }
    elsif current_customer?
      @complaints = Complaint.all.filter { |c| c.customer == current_account.customer }
    end
  end

  # GET /complaints/1 or /complaints/1.json
  def show
  end

  # GET /complaints/new
  def new
    @complaint = Complaint.new
  end

  # GET /complaints/1/edit
  def edit
  end

  # POST /complaints or /complaints.json
  def create
    @complaint = Complaint.new(complaint_params)

    respond_to do |format|
      if @complaint.save
        format.html { redirect_to @complaint, notice: "成功创建投诉！" }
        format.json { render :show, status: :created, location: @complaint }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @complaint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /complaints/1 or /complaints/1.json
  def update
    respond_to do |format|
      if @complaint.update(complaint_params)
        format.html { redirect_to @complaint, notice: "成功更新投诉！" }
        format.json { render :show, status: :ok, location: @complaint }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @complaint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /complaints/1 or /complaints/1.json
  def destroy
    @complaint.destroy
    respond_to do |format|
      format.html { redirect_to complaints_url, notice: "成功销毁投诉！" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_complaint
      @complaint = Complaint.find(params[:id])
    end

    def set_handle_complaint
      @complaint = Complaint.find(params[:complaint_id])
    end

    # Only allow a list of trusted parameters through.
    def complaint_params
      params.require(:complaint).permit(:customer_id, :seller_id, :content)
    end

    def complaint_handle_params
      params.require(:complaint).permit(:admin_id)
    end
end
