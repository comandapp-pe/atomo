class Admin::SessionsController < ApplicationController
  protect_from_forgery with: :null_session

  # GET /admin/session/new
  def new
    admin_session_id = session[:current_admin_session_id]

    @admin_session = Admin::Session.find_by(id: admin_session_id)

    respond_to do |format|
      if @admin_session
        format.html { redirect_to admin_orders_url, notice: 'Ya tenías una sesión activa, así que fuiste redireccionado automáticamente.' }
      else
        @admin_session = Admin::Session.new

        format.html { render :new }
      end
    end
  end

  # POST /admin/session or /admin/session.json
  def create
    @admin_user = Admin::User.find_by(admin_session_params)

    @admin_session = Admin::Session.new(admin_user: @admin_user)

    respond_to do |format|
      if @admin_session.save
        session[:current_admin_session_id] = @admin_session.id

        format.html { redirect_to admin_orders_url }
        format.json { render :show, status: :created, location: @admin_session }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/session or /admin/session.json
  def destroy
    admin_session_id = session[:current_admin_session_id]

    @admin_session = Admin::Session.find_by(id: admin_session_id)

    respond_to do |format|
      if @admin_session
        session.delete :current_admin_session_id

        @admin_session.destroy

        format.html { redirect_to new_admin_session_url, notice: "Cerraste sesión exitosamente." }
        format.json { head :no_content }
      else
        format.html { redirect_to new_admin_session_url }
        format.json { head :unprocessable_entity }
      end
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def admin_session_params
    params.require(:admin_session).permit(:tag, :password)
  end
end
