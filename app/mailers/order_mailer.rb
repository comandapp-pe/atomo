# typed: true
class OrderMailer < ApplicationMailer
  default from: 'noresponder@comandapp.pe'

  def confirmation_email
    @order = params[:order]

    attachments.inline['logo.png'] = File.read('/Users/ioaquine/Downloads/quipu/socialspots/app/assets/images/logo.png')

    mail to: @order.customer_email, subject: "Tu orden en Social Spots fue confirmada"
  end
end
