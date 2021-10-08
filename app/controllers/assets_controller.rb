class AssetsController < ApplicationController
  before_action :set_order

  # GET /assets or /assets.json
  def index
    @assets = @order.assets
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
    @asset = params[:assets]

    @order.assets.attach(@asset)

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: "Asset was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
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
    @asset.destroy
    respond_to do |format|
      format.html { redirect_to assets_url, notice: "Asset was successfully destroyed." }
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
