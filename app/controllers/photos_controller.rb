class PhotosController < ApplicationController
  before_action :set_order, only: [:index, :new, :create]
  
  # GET /photos or /photos.json
  def index
  end

  # GET /photos/1 or /photos/1.json
  def show
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # GET /photos/1/edit
  def edit
  end

  # POST /photos or /photos.json
  def create
    @signed_id = params[:photos]

    @blob = ActiveStorage::Blob.find_signed(@signed_id)

    @blob.analyze

    @order.photos.attach(@blob)

    respond_to do |format|
      if @order.save
        @photo = ActiveStorage::Attachment.find_by(blob_id: @blob.id)

        format.js
        format.html { redirect_to [:admin, @order], notice: "Foto creada exitosamente." }
        format.json { render :show, status: :created, location: @order }
      else
        format.js
        format.html { render 'admin/orders/show', status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photos/1 or /photos/1.json
  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to @photo, notice: "Photo was successfully updated." }
        format.json { render :show, status: :ok, location: @photo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1 or /photos/1.json
  def destroy
    @photo = ActiveStorage::Attachment.find(params[:id])

    @order = Order.find(@photo.record_id)

    @photo.purge
    respond_to do |format|
      format.js
      format.html { redirect_to [:admin, @order], notice: "La foto fue borrada exitosamente." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:order_id])
  end

  # Only allow a list of trusted parameters through.
  def photo_params
    params.fetch(:photo, {})
  end
end
