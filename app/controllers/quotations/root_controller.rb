class Quotations::RootController < ApplicationController
  before_action :set_quotations_root, only: %i[ show edit update destroy ]

  # GET /quotations/root or /quotations/root.json
  def index
    @product = Product.find(params[:product_id])
  end

  # GET /quotations/root/1 or /quotations/root/1.json
  def show
  end

  # GET /quotations/root/new
  def new
    @product = Product.find(params[:product_id])
  end

  # GET /quotations/root/1/edit
  def edit
  end

  # POST /quotations/root or /quotations/root.json
  def create
    @quotations_root = Quotations::Root.new(quotations_root_params)

    respond_to do |format|
      if @quotations_root.save
        format.html { redirect_to @quotations_root, notice: "Root was successfully created." }
        format.json { render :show, status: :created, location: @quotations_root }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @quotations_root.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quotations/root/1 or /quotations/root/1.json
  def update
    respond_to do |format|
      if @quotations_root.update(quotations_root_params)
        format.html { redirect_to @quotations_root, notice: "Root was successfully updated." }
        format.json { render :show, status: :ok, location: @quotations_root }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @quotations_root.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotations/root/1 or /quotations/root/1.json
  def destroy
    @quotations_root.destroy
    respond_to do |format|
      format.html { redirect_to quotations_roots_url, notice: "Root was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quotations_root
      @quotations_root = Quotations::Root.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def quotations_root_params
      params.fetch(:quotations_root, {})
    end
end
