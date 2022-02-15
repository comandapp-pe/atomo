class Admin::LocutionsController < ApplicationController
    before_action :set_locution, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
    def index
        @locutions = Locution.all.order(created_at: :desc)
      end

      # GET /admin/locutions/1 or /admin/locutions/1.json
    def show
    end
  
    def new
        @locution = Locution.new
    end

     # GET /admin/products/1/edit
  def edit
  end

    # POST /admin/locutions or /admin/locutions.json
    def create
        @locution = Locution.new(admin_locution_create_params)

        respond_to do |format|
        if @locution.save
            format.html { redirect_to [:admin, @locution], notice: "Creaste una locucion exitosamente." }
            format.json { render :show, status: :created, location: @locution }
        else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @locution.errors, status: :unprocessable_entity }
        end
        end
    end

    def destroy
      @locution.destroy
      respond_to do |format|
        format.html { redirect_to admin_locutions_url, notice: "Borraste una locucion exitosamente." }
        format.json { head :no_content }
      end
    end

    def admin_locution_create_params
        params.require(:locution).permit(:vimeo_url)
    end

    # Use callbacks to share common setup or constraints between actions.
  def set_locution
    @locution = Locution.find(params[:id])
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
