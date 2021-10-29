class Quotations::LengthsController < ApplicationController
  before_action :set_quotations_length, only: %i[ show edit update destroy ]

  # GET /quotations/lengths or /quotations/lengths.json
  def index
    @quotations_lengths = Quotations::Length.all
  end

  # GET /quotations/lengths/1 or /quotations/lengths/1.json
  def show
  end

  # GET /quotations/lengths/new
  def new
    @product = Product.find(params[:product_id])

    @format = params[:format]
  end

  # GET /quotations/lengths/1/edit
  def edit
  end

  # POST /quotations/lengths or /quotations/lengths.json
  def create
    @quotations_length = Quotations::Length.new(quotations_length_params)

    respond_to do |format|
      if @quotations_length.save
        format.html { redirect_to @quotations_length, notice: "Length was successfully created." }
        format.json { render :show, status: :created, location: @quotations_length }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @quotations_length.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quotations/lengths/1 or /quotations/lengths/1.json
  def update
    respond_to do |format|
      if @quotations_length.update(quotations_length_params)
        format.html { redirect_to @quotations_length, notice: "Length was successfully updated." }
        format.json { render :show, status: :ok, location: @quotations_length }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @quotations_length.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotations/lengths/1 or /quotations/lengths/1.json
  def destroy
    @quotations_length.destroy
    respond_to do |format|
      format.html { redirect_to quotations_lengths_url, notice: "Length was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quotations_length
      @quotations_length = Quotations::Length.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def quotations_length_params
      params.fetch(:quotations_length, {})
    end
end
