class Admin::ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /admin/products or /admin/products.json
  def index
    @products = Product.all.order(created_at: :desc)
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
    @product = Product.new(admin_product_create_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to [:admin, @product], notice: "Creaste un producto exitosamente." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/products/1 or /admin/products/1.json
  def update
    respond_to do |format|
      if @product.update(admin_product_update_params)
        format.html { redirect_to [:admin, @product], notice: "Actualizaste el producto exitosamente." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/products/1 or /admin/products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to admin_products_url, notice: "Borraste un producto exitosamente." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  def admin_product_create_params
    params.require(:product).permit(:vimeo_url)
  end

  def admin_product_update_params
    params.require(:product).permit(:name, :description, :category_id, :published)
  end

  def authenticate_user!
    admin_session_id = session[:current_admin_session_id]

    @admin_session = Admin::Session.find_by(id: admin_session_id)

    return if @admin_session

    respond_to do |format|
      format.html { redirect_to new_admin_session_url, notice: 'Debes iniciar sesi??n antes de ingresar a esta p??gina.' }
    end
  end
end
