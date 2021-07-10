# typed: true
class OrderMailer < ApplicationMailer
  default from: 'joaquin.meza.prueba@gmail.com'

  def confirmation_email
    @order = params[:order]

    @url = 'http://example.com'

    mail to: @order.customer_email, subject: "Tu orden en Átomo Digital fue confirmada"
  end
end
