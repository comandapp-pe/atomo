class Admin::ProductsController < ApplicationController
  before_action :set_admin_product, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /admin/products or /admin/products.json
  def index
    @products = Product.all
  end

  # GET /admin/products/1 or /admin/products/1.json
  def show
  end

  # GET /admin/products/new
  def new
    @product = Product.new
  end

  # GET /admin/products/1/edit
  def edit
  end

  # POST /admin/products or /admin/products.json
  def create
    @admin_product = Product.new(admin_product_params)

    respond_to do |format|
      if @admin_product.save
        format.html { redirect_to @admin_product, notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @admin_product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/products/1 or /admin/products/1.json
  def update
    respond_to do |format|
      if @admin_product.update(admin_product_params)
        format.html { redirect_to @admin_product, notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @admin_product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/products/1 or /admin/products/1.json
  def destroy
    @admin_product.destroy
    respond_to do |format|
      format.html { redirect_to admin_products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_admin_product
    @admin_product = Admin::Product.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def admin_product_params
    params.fetch(:admin_product, {})
  end

  def authenticate_user!
    admin_session_id = session[:current_admin_session_id]

    @admin_session = Admin::Session.find_by(id: admin_session_id)

    return if @admin_session

    respond_to do |format|
      format.html { redirect_to new_admin_session_url, notice: 'You must authenticate before accessing this page.' }
    end
  end
end