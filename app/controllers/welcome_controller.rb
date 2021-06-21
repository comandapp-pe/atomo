class WelcomeController < ApplicationController
  protect_from_forgery with: :null_session

  def index
  end

  def create
    request.request_parameters

    pid = request.request_parameters["IPN_PID"].first

    pname = request.request_parameters["IPN_PNAME"].first

    ipn_date = request.request_parameters["IPN_DATE"]

    date = request.request_parameters["IPN_DATE"]

    key = 'm&fsBk(ZxhMe)D%!|WqJ'

    data = [pid, pname, ipn_date, date].map {|value| "#{value.bytesize}#{value}"}.join.to_s

    result = OpenSSL::HMAC.hexdigest("md5", key, data)

    tag = "<EPAYMENT>#{date}|#{result}</EPAYMENT>"

    OrderMailer.with(
      order_id: params[:ORDERNO],
      customer_email: params[:CUSTOMEREMAIL],
      first_name: params[:FIRSTNAME],
      last_name: params[:LASTNAME],
      sale_date: params[:SALEDATE],
      payment_method: params[:PAYMETHOD],
      currency: params[:CURRENCY],
      ids: params[:IPN_PID],
      codes: params[:IPN_PCODE],
      products: params[:IPN_PNAME],
      total: params[:IPN_TOTAL],
    ).confirmation_email.deliver_later

    render html: tag.html_safe, layout: 'application'
  end
end
