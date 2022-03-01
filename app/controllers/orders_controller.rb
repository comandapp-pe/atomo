# typed: false
class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]

  skip_before_action :verify_authenticity_token

  # GET /orders or /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @product = Product.find(params[:product_id])
    @locutions = Locution.where({ published: true }).order(name: :asc)

    @length = params[:length]
    @format = params[:format]
    @loc = params[:loc]
    
    unless @length
      render 'length_selection'
      return
    end

    unless @format
      render 'format_selection'
      return
    end

    unless @loc
      render 'loc_selection'
      return
    end

    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    product = Product.find_by(checkout_code: params['IPN_PCODE'].first)

    product_checkout_code = params['IPN_PID'].first

    product_checkout_format = 'vertical'

    product_checkout_length = 30

    customer_email = params["CUSTOMEREMAIL"]

    customer_first_name = params["FIRSTNAME"]

    customer_last_name = params["LASTNAME"]

    checkout_code = params["REFNO"]

    payment_method = params["PAYMETHOD"]

    currency = params["CURRENCY"]

    sold_at = params["SALEDATE"]

    checkout_commission = params["IPN_COMMISSION"]

    total = params["IPN_TOTAL"][0]

    @order = Order.new(
      checkout_code: checkout_code,
      customer_email: customer_email,
      customer_first_name: customer_first_name,
      customer_last_name: customer_last_name,
      product: product,
      format: product_checkout_format,
      length: product_checkout_length,
      payment_method: payment_method,
      currency: currency,
      sold_at: sold_at,
      checkout_commission: checkout_commission,
      total: total
    )

    pid = params["IPN_PID"].first

    pname = params["IPN_PNAME"].first

    ipn_date = params["IPN_DATE"]

    key = '?s=%mWtHCUlTdS)7~BRp'

    data = [pid, pname, ipn_date, ipn_date].map { |value| "#{value.bytesize}#{value}" }.join.to_s

    result = OpenSSL::HMAC.hexdigest("md5", key, data)

    tag = "<EPAYMENT>#{ipn_date}|#{result}</EPAYMENT>"

    respond_to do |format|
      if @order.save
        OrderMailer.with(order: @order).confirmation_email.deliver_later

        format.html { render html: tag.html_safe, layout: 'application' }
      else
        puts @order.errors.full_messages
        format.html { head :unprocessable_entity }
      end
    end
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
    params.require(:order)
  end
end
