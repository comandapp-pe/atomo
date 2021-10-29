class Quotations::LeadsController < ApplicationController
  before_action :set_quotations_lead, only: %i[ show edit update destroy ]

  # GET /quotations/leads or /quotations/leads.json
  def index
    @quotations_leads = Quotations::Lead.all
  end

  # GET /quotations/leads/1 or /quotations/leads/1.json
  def show
  end

  # GET /quotations/leads/new
  def new
    @product = Product.find(params[:product_id])
  end

  # GET /quotations/leads/1/edit
  def edit
  end

  # POST /quotations/leads or /quotations/leads.json
  def create
    @quotations_lead = Quotations::Lead.new(quotations_lead_params)

    respond_to do |format|
      if @quotations_lead.save
        format.html { redirect_to @quotations_lead, notice: "Lead was successfully created." }
        format.json { render :show, status: :created, location: @quotations_lead }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @quotations_lead.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quotations/leads/1 or /quotations/leads/1.json
  def update
    respond_to do |format|
      if @quotations_lead.update(quotations_lead_params)
        format.html { redirect_to @quotations_lead, notice: "Lead was successfully updated." }
        format.json { render :show, status: :ok, location: @quotations_lead }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @quotations_lead.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotations/leads/1 or /quotations/leads/1.json
  def destroy
    @quotations_lead.destroy
    respond_to do |format|
      format.html { redirect_to quotations_leads_url, notice: "Lead was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quotations_lead
      @quotations_lead = Quotations::Lead.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def quotations_lead_params
      params.fetch(:quotations_lead, {})
    end
end
