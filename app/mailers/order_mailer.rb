# typed: true
class OrderMailer < ApplicationMailer
  default from: 'waterquarks@gmail.com'

  def confirmation_email
    @customer_email = params[:customer_email]

    @first_name = params[:first_name]

    @last_name = params[:last_name]

    @order_id = params[:order_id]

    @sale_date = params[:sale_date]

    @payment_method = params[:payment_method]

    @currency = params[:currency]

    @products = params[:products]

    @total = params[:total]

    @url  = 'http://example.com'

    mail to: @customer_email, subject: "Your order ##{@order_id} has been confirmed"
  end
end
