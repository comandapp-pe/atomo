class Admin::FaqsController < ApplicationController
    before_action :set_faq, only: %i[ show edit update destroy ]
    before_action :authenticate_user!

    # GET /admin/categories or /admin/categories.json
    def index
      @faqs = Faq.all
    end

  # GET /admin/categories/1 or /admin/categories/1.json
  def show
  end

  # GET /admin/categories/new
  def new
    @faq = Faq.new
  end

  # POST /admin/categories or /admin/categories.json
  def create
    @faq = Faq.new(faq_params)

    respond_to do |format|
      if @faq.save
        format.html { redirect_to [:admin, @faq], notice: "Creaste una Pregunta Frecuente exitosamente." }
        format.json { render :show, status: :created, location: @faq }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @faq.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/categories/1 or /admin/categories/1.json
  def destroy
    @faq.destroy
    respond_to do |format|
      format.html { redirect_to admin_faqs_url, notice: "Borraste una Pregunta Frecuente exitosamente." }
      format.json { head :no_content }
    end
  end

  # GET /admin/categories/1/edit
  def edit
  end

  # Only allow a list of trusted parameters through.
  def faq_params
    params.require(:faq).permit(:question, :answer)
  end

  # PATCH/PUT /admin/categories/1 or /admin/categories/1.json
  def update
    respond_to do |format|
      if @faq.update(faq_params)
        format.html { redirect_to [:admin, @faq], notice: "Actualizaste la Pregunta Frecuente exitosamente." }
        format.json { render :show, status: :ok, location: @faq }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @faq.errors, status: :unprocessable_entity }
      end
    end
  end

    # Use callbacks to share common setup or constraints between actions.
  def set_faq
    @faq = Faq.find(params[:id])
  end

  def authenticate_user!
    admin_session_id = session[:current_admin_session_id]

    @admin_session = Admin::Session.find_by(id: admin_session_id)

    return if @admin_session

    respond_to do |format|
      format.html { redirect_to new_admin_session_url, notice: 'Debes iniciar sesión antes de ingresar a esta página.' }
    end
  end
end
