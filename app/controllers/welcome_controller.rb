class WelcomeController < ApplicationController
  protect_from_forgery with: :null_session

  def index
  end

  def create
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

    head :ok
  end
end
