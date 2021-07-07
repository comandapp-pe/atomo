# typed: true
class OrderMailer < ApplicationMailer
  default from: 'joaquin.meza.prueba@gmail.com'

  def confirmation_email
    @order = params[:order]

    @url = 'http://example.com'

    mail to: @order.customer_email, subject: "Tu orden ##{@order.checkout_id} fue confirmada"
  end
end
