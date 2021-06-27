# typed: false
class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]

  protect_from_forgery with: :null_session

  # GET /orders or /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    products = params['IPN_PID'].zip(params['IPN_PCODE'], params['IPN_PNAME'], params['IPN_QTY'], params['IPN_PRICE'])

    products = products.map { |array| [:id, :code, :name, :quantity, :price].zip(array) }.map(&:to_h)

    products = products.map do |product|
      text = params["IPN_CUSTOM_#{product[:id]}_TEXT"].map(&:downcase).map(&:to_sym)
      value = params["IPN_CUSTOM_#{product[:id]}_VALUE"].map(&:downcase)

      meta = text.zip(value).to_h

      { **product, **meta }
    end

    pid = request.request_parameters["IPN_PID"].first

    pname = request.request_parameters["IPN_PNAME"].first

    ipn_date = request.request_parameters["IPN_DATE"]

    key = 'm&fsBk(ZxhMe)D%!|WqJ'

    data = [pid, pname, ipn_date, ipn_date].map { |value| "#{value.bytesize}#{value}" }.join.to_s

    result = OpenSSL::HMAC.hexdigest("md5", key, data)

    tag = "<EPAYMENT>#{ipn_date}|#{result}</EPAYMENT>"

    OrderMailer.with(
      order_id: params["ORDERNO"],
      customer_email: params["CUSTOMEREMAIL"],
      first_name: params["FIRSTNAME"],
      last_name: params["LASTNAME"],
      sale_date: params["SALEDATE"],
      products: products,
      payment_method: params["PAYMETHOD"],
      currency: params["CURRENCY"],
      total: params["IPN_TOTAL"],
    ).confirmation_email.deliver_later

    render html: tag.html_safe, layout: 'application'
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def order_params
    params.require(:order).permit({})
  end
end
