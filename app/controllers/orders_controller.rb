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

    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    # params = {"SALEDATE"=>"2021-07-06 04:11:04", "REFNO"=>"156597478", "REFNOEXT"=>"", "ORDERNO"=>"77", "ORDERSTATUS"=>"PAYMENT_AUTHORIZED", "PAYMETHOD"=>"Visa/MasterCard", "FIRSTNAME"=>"John", "LASTNAME"=>"Doe", "COMPANY"=>"", "REGISTRATIONNUMBER"=>"", "FISCALCODE"=>"", "CBANKNAME"=>"", "CBANKACCOUNT"=>"", "ADDRESS1"=>"-", "ADDRESS2"=>"", "CITY"=>"-", "STATE"=>"-", "ZIPCODE"=>"-", "COUNTRY"=>"Peru", "PHONE"=>"", "FAX"=>"", "CUSTOMEREMAIL"=>"joaquin.meza@riqra.com", "FIRSTNAME_D"=>"John", "LASTNAME_D"=>"Doe", "COMPANY_D"=>"", "ADDRESS1_D"=>"-", "ADDRESS2_D"=>"", "CITY_D"=>"-", "STATE_D"=>"-", "ZIPCODE_D"=>"-", "COUNTRY_D"=>"Peru", "PHONE_D"=>"", "IPADDRESS"=>"179.6.215.254", "CURRENCY"=>"USD", "IPN_PID"=>["36497829"], "IPN_PNAME"=>["1.Conociéndonos"], "IPN_PCODE"=>["9Aojfku714"], "IPN_INFO"=>[""], "IPN_QTY"=>["1"], "IPN_PRICE"=>["20.00"], "IPN_VAT"=>["0.00"], "IPN_VER"=>["1.0"], "IPN_DISCOUNT"=>["0.00"], "IPN_PROMONAME"=>[""], "IPN_DELIVEREDCODES"=>[""], "IPN_TOTAL"=>["20.00"], "IPN_TOTALGENERAL"=>"20.00", "IPN_SHIPPING"=>"0.00", "IPN_SHIPPING_TAX"=>"0.00", "IPN_COMMISSION"=>"1.80", "IPN_CUSTOM_36497829_TEXT"=>["Format", "Length"], "IPN_CUSTOM_36497829_VALUE"=>["vertical", "15"], "IPN_DATE"=>"20210706041120", "HASH"=>"6f288d7b6136ff2a178e39b85c98548b"}

    product = Product.find_by(checkout_code: params['IPN_PCODE'].first)

    product_checkout_code = params['IPN_PID'].first

    product_checkout_additional_fields_text = params["IPN_CUSTOM_#{product_checkout_code}_TEXT"]

    product_checkout_additional_fields_value = params["IPN_CUSTOM_#{product_checkout_code}_VALUE"]

    product_checkout_additional_fields = product_checkout_additional_fields_text.zip(product_checkout_additional_fields_value).to_h

    product_checkout_format = product_checkout_additional_fields['Format']

    product_checkout_length = product_checkout_additional_fields['Length']

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

    key = 'm&fsBk(ZxhMe)D%!|WqJ'

    data = [pid, pname, ipn_date, ipn_date].map { |value| "#{value.bytesize}#{value}" }.join.to_s

    result = OpenSSL::HMAC.hexdigest("md5", key, data)

    tag = "<EPAYMENT>#{ipn_date}|#{result}</EPAYMENT>"

    respond_to do |format|
      if @order.save
        OrderMailer.with(order: @order).confirmation_email.deliver_later

        format.html { render html: tag.html_safe, layout: 'application' }
      else
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
