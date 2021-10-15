class LocutionsController < ApplicationController
  before_action :set_order, only: [:index, :new, :create]

  # GET /locutions or /locutions.json
  def index
    @locutions = Locution.all
  end

  # GET /locutions/1 or /locutions/1.json
  def show
  end

  # GET /locutions/new
  def new
    @locution = Locution.new
  end

  # GET /locutions/1/edit
  def edit
  end

  # POST /locutions or /locutions.json
  def create
    @file = params[:locutions]

    @blob = ActiveStorage::Blob.create_and_upload!(
      io: @file,
      filename: @file.original_filename,
      content_type: @file.content_type
    )

    @blob.analyze

    @order.locutions.attach(@blob)

    respond_to do |format|
      if @order.save
        format.html { redirect_to [:admin, @order], notice: "Locution was successfully created." }
        format.json { render :show, status: :created, location: @locution }
      else
        format.html { render 'admin/order/show', status: :unprocessable_entity }
        format.json { render json: @locution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locutions/1 or /locutions/1.json
  def update
    respond_to do |format|
      if @locution.update(locution_params)
        format.html { redirect_to @locution, notice: "Locution was successfully updated." }
        format.json { render :show, status: :ok, location: @locution }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @locution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locutions/1 or /locutions/1.json
  def destroy

    @locution = ActiveStorage::Attachment.find(params[:id])

    @order = Order.find(@locution.record_id)

    @locution.purge
    respond_to do |format|
      format.html { redirect_to [:admin, @order], notice: "Locution was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:order_id])
    end
    # Only allow a list of trusted parameters through.
    def locution_params
      params.fetch(:locution, {})
    end
end
