class FontsController < ApplicationController
  before_action :set_order, only: [:index, :new, :create]

  # GET /fonts or /fonts.json
  def index
    @fonts = Font.all
  end

  # GET /fonts/1 or /fonts/1.json
  def show
  end

  # GET /fonts/new
  def new
    @font = Font.new
  end

  # GET /fonts/1/edit
  def edit
  end

  # POST /fonts or /fonts.json
  def create
    @file = params[:fonts]

    @blob = ActiveStorage::Blob.create_and_upload!(
      io: @file,
      filename: @file.original_filename,
      content_type: @file.content_type
    )

    @blob.analyze

    @order.fonts.attach(@blob)

    @font = ActiveStorage::Attachment.find_by(blob_id: @blob.id)

    respond_to do |format|
      if @order.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(:new_font, partial: 'fonts/form', locals: { order: @order }),
            turbo_stream.append(:all_fonts, partial: 'fonts/font', locals: { font: @font })
          ]
        end
        format.html { redirect_to [:admin, @order], notice: "Font was successfully created." }
        format.json { render :show, status: :created, location: @font }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(:new_font, partial: 'fonts/form', locals: { order: @order }) }
        format.html { render 'admin/orders/show', status: :unprocessable_entity }
        format.json { render json: @font.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fonts/1 or /fonts/1.json
  def update
    respond_to do |format|
      if @font.update(font_params)
        format.html { redirect_to @font, notice: "Font was successfully updated." }
        format.json { render :show, status: :ok, location: @font }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @font.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fonts/1 or /fonts/1.json
  def destroy
    @font = ActiveStorage::Attachment.find(params[:id])

    @order = Order.find(@font.record_id)

    @font.purge
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@font) }
      format.html { redirect_to [:admin, @order], notice: "Font was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:order_id])
  end

  # Only allow a list of trusted parameters through.
  def font_params
    params.fetch(:font, {})
  end
end
