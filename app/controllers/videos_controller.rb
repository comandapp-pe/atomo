class VideosController < ApplicationController
  before_action :set_order, only: [:index, :new, :create]

  # GET /assets or /assets.json
  def index
  end

  # GET /assets/1 or /assets/1.json
  def show
  end

  # GET /assets/new
  def new
    @asset = Asset.new
  end

  # GET /assets/1/edit
  def edit
  end

  # POST /assets or /assets.json
  def create
    @file = params[:videos]

    @blob = ActiveStorage::Blob.create_and_upload!(
      io: @file,
      filename: @file.original_filename,
      content_type: @file.content_type
    )

    @blob.analyze

    @order.videos.attach(@blob)

    respond_to do |format|
      if @order.save
        @video = ActiveStorage::Attachment.find_by(blob_id: @blob.id)

        format.turbo_stream do
          flash.now[:notice] = 'Video creado exitosamente.'

          render turbo_stream: [
            turbo_stream.replace(:flash, partial: 'application/flash'),
            turbo_stream.replace(:new_video, partial: 'videos/form', locals: { order: @order }),
            turbo_stream.append(:all_videos, partial: 'videos/video', locals: { video: @video })
          ]
        end
        format.html { redirect_to [:admin, @order], notice: "El asset fue creado exitosamente." }
        format.json { render :show, status: :created, location: @order }
      else
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(:new_video, partial: 'videos/form', locals: { order: @order })
          ]
        end
        format.html { render 'admin/orders/show', status: :unprocessable_entity }
        format.json { render json: @asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assets/1 or /assets/1.json
  def update
    respond_to do |format|
      if @asset.update(asset_params)
        format.html { redirect_to @asset, notice: "Asset was successfully updated." }
        format.json { render :show, status: :ok, location: @asset }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assets/1 or /assets/1.json
  def destroy
    @asset = ActiveStorage::Attachment.find(params[:id])

    @order = Order.find(@asset.record_id)

    @asset.purge

    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = 'Video borrado exitosamente.'

        render turbo_stream: [
          turbo_stream.replace(:flash, partial: 'application/flash'),
          turbo_stream.remove(@asset)
        ]
      end
      format.html { redirect_to [:admin, @order], notice: "Asset was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:order_id])
  end

  # Only allow a list of trusted parameters through.
  def asset_params
    params.fetch(:asset, {})
  end
end
