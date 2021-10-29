# typed: true
class OrderMailer < ApplicationMailer
  default from: 'noresponder@comandapp.pe'

  def confirmation_email
    @order = params[:order]

    attachments.inline['logo.png'] = File.read(Rails.root.to_s + '/app/assets/images/logo.png')

    mail to: @order.customer_email, subject: "Tu orden en Átomo Digital fue confirmada"
  end
end
