class Admin::SessionsController < ApplicationController
  before_action :set_admin_session, only: %i[ show edit update destroy ]

  # GET /admin/sessions or /admin/sessions.json
  def index
    @admin_sessions = Admin::Session.all
  end

  # GET /admin/sessions/1 or /admin/sessions/1.json
  def show
  end

  # GET /admin/sessions/new
  def new
    @admin_session = Admin::Session.new
  end

  # GET /admin/sessions/1/edit
  def edit
  end

  # POST /admin/sessions or /admin/sessions.json
  def create
    @admin_user = Admin::User.find_by(tag: admin_session_params[:tag], password: admin_session_params[:password])

    @admin_session = Admin::Session.new(admin_user_id: @admin_user.id)

    respond_to do |format|
      if @admin_session.save
        format.html { redirect_to @admin_session, notice: "Session was successfully created." }
        format.json { render :show, status: :created, location: @admin_session }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/sessions/1 or /admin/sessions/1.json
  def update
    respond_to do |format|
      if @admin_session.update(admin_session_params)
        format.html { redirect_to @admin_session, notice: "Session was successfully updated." }
        format.json { render :show, status: :ok, location: @admin_session }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/sessions/1 or /admin/sessions/1.json
  def destroy
    @admin_session.destroy
    respond_to do |format|
      format.html { redirect_to admin_sessions_url, notice: "Session was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_session
      @admin_session = Admin::Session.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_session_params
      params.require(:admin_session).permit(:tag, :password)
    end
end
