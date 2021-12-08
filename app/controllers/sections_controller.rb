class SectionsController < ApplicationController
  before_action :set_section, only: %i[ show edit update destroy ]
  before_action :create_authenticate, only: [:create]
  before_action :ban, only: [:index]

  def create_authenticate
    redirect_to commodity_url(Commodity.find(params[:commodity_id])), alert: "Buy it first" unless current_customer? &&
      current_account.customer.orders.filter { |o| o.done }
                     .exists? { |o| o.commodity == Commodity.find(params[:commodity_id]) }
  end

  def ban
    redirect_to commodity_url(Commodity.find(params[:commodity_id])), alert: "Illegal Behavior"
  end

  # GET /sections or /sections.json
  def index
    @sections = Section.all
  end

  # GET /sections/1 or /sections/1.json
  def show
  end

  # GET /sections/new
  def new
    @section = Section.new
  end

  # GET /sections/1/edit
  def edit
  end

  # POST /sections or /sections.json
  def create
    @section = Section.new(section_params)

    respond_to do |format|
      if @section.save
        format.html { redirect_to commodity_section_url(@section.record.order.commodity, @section),
                                  notice: "Section was successfully created." }
        format.json { render :show, status: :created, location: @section }
      else
        format.html { render customer_record_url, status: :unprocessable_entity }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sections/1 or /sections/1.json
  def update
    respond_to do |format|
      if @section.update(section_params)
        format.html { redirect_to @section, notice: "Section was successfully updated." }
        format.json { render :show, status: :ok, location: @section }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sections/1 or /sections/1.json
  def destroy
    @section.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: "Section was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_section
      @section = Section.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def section_params
      params.require(:section).permit(:grade, :record_id)
    end
end
