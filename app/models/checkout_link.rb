# typed: true

class CheckoutLink < ApplicationRecord

  belongs_to :product

  validates :format, presence: true
  validates :length, presence: true

  validates :format, inclusion: { in: ['horizontal', 'vertical', 'square'] }
  validates :length, inclusion: { in: [15, 30, 60] }

  def url
    signable = {
      currency: 'USD',
      price: "USD:#{100}",
      prod: self.product.code,
      qty: '1',
      'return-type': 'redirect',
      'return-url': 'https://serene-woodland-34280.herokuapp.com',
    }.sort.to_h # the signable's keys must be ordered alphabetically

    concat = signable.to_a.map { |key, value| "#{value.length}#{value}" }.join

    secret_word = 'P4nS44ff!@NX5bPV8Wkk9xe8Rk3$vgTZxgU4sYUcCEzKS-wYyfAtvcBEAN!yQVA&'

    args = {
      'empty-cart': '1',
      merchant: '251019015085',
      'product-additional-fields': "format:#{self.format},length:#{self.length}",
    }.merge(signable)

    signature = OpenSSL::HMAC.hexdigest("sha256", secret_word, concat)

    query_params = args.clone.merge({ 'return-url': CGI.escape(args[:'return-url']) }).to_a.map { |key, value| "#{key}=#{value}" }.join('&') + "&signature=#{signature}"

    checkout_url = "https://secure.2checkout.com/checkout/buy?#{query_params}"

    checkout_url
  end
end
