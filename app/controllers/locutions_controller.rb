class LocutionsController < ApplicationController
  before_action :set_order, only: [:index, :new, :create]

  # GET /locutions or /locutions.json
  def index
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

    @locution = ActiveStorage::Attachment.find_by(blob_id: @blob.id)

    respond_to do |format|
      if @order.save
        format.turbo_stream do
          flash.now[:notice] = 'Locución creada exitosamente.'

          render turbo_stream: [
            turbo_stream.replace(:flash, partial: 'application/flash'),
            turbo_stream.replace(:new_locution, partial: 'locutions/form', locals: { order: @order }),
            turbo_stream.append(:all_locutions, partial: 'locutions/locution', locals: { locution: @locution })
          ]
        end
        format.html { redirect_to [:admin, @order], notice: "Locution was successfully created." }
        format.json { render :show, status: :created, location: @locution }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(:new_locution, partial: 'locutions/form', locals: { order: @order }) }
        format.html { render 'admin/orders/show', status: :unprocessable_entity }
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
      format.turbo_stream do
        flash.now[:notice] = 'Locución borrada exitosamente.'

        render turbo_stream: [
          turbo_stream.replace(:flash, partial: 'application/flash'),
          turbo_stream.remove(@locution)
        ]
      end
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
