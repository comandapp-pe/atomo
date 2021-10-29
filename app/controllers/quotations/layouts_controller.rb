class Quotations::LayoutsController < ApplicationController
  before_action :set_quotations_layout, only: %i[ show edit update destroy ]

  # GET /quotations/layouts or /quotations/layouts.json
  def index
    @quotations_layouts = Quotations::Layout.all
  end

  # GET /quotations/layouts/1 or /quotations/layouts/1.json
  def show
  end

  # GET /quotations/layouts/new
  def new
    @product = Product.find(params[:product_id])
  end

  # GET /quotations/layouts/1/edit
  def edit
  end

  # POST /quotations/layouts or /quotations/layouts.json
  def create
    @product = Product.find(params[:product_id])

    respond_to do |format|
      if true
        format.html { redirect_to new_quotations_length_url({ product_id: @product.id, layout: params[:layout] }) }
        format.json { render :show, status: :created, location: @quotations_layout }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @quotations_layout.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quotations/layouts/1 or /quotations/layouts/1.json
  def update
    respond_to do |format|
      if @quotations_layout.update(quotations_layout_params)
        format.html { redirect_to @quotations_layout, notice: "Layout was successfully updated." }
        format.json { render :show, status: :ok, location: @quotations_layout }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @quotations_layout.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotations/layouts/1 or /quotations/layouts/1.json
  def destroy
    @quotations_layout.destroy
    respond_to do |format|
      format.html { redirect_to quotations_layouts_url, notice: "Layout was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quotations_layout
      @quotations_layout = Quotations::Layout.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def quotations_layout_params
      params.fetch(:quotations_layout, {})
    end
end
