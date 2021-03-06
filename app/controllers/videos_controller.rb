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
    @signed_id = params[:videos]

    @blob = ActiveStorage::Blob.find_signed(@signed_id)

    @blob.analyze

    @order.videos.attach(@blob)

    respond_to do |format|
      if @order.save
        @video = ActiveStorage::Attachment.find_by(blob_id: @blob.id)

        format.js
        format.html { redirect_to [:admin, @order], notice: "Video creado exitosamente." }
        format.json { render :show, status: :created, location: @order }
      else
        format.js
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
    @video = ActiveStorage::Attachment.find(params[:id])

    @order = Order.find(@video.record_id)

    @video.purge

    respond_to do |format|
      format.js
      format.html { redirect_to [:admin, @order], notice: "Video borrado exitosamente." }
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
