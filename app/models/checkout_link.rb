class CheckoutLink < ApplicationRecord
  belongs_to :product

  validates :format, presence: true
  validates :length, presence: true

  validates :format, inclusion: { in: ['horizontal', 'vertical', 'square'] }
  validates :length, inclusion: { in: [15, 30, 60] }

  def url
    price = case self.length
              when 15 then 20
              when 30 then 30
              when 60 then 40
            end

    signable = {
      currency: 'USD',
      price: "USD:#{price}",
      prod: self.product.checkout_code,
      qty: '1',
      'return-type': 'redirect',
      'return-url': 'https://socialspots.herokuapp.com/thanks',
    }.sort.to_h # the signable's keys must be ordered alphabetically

    concat = signable.to_a.map { |key, value| "#{value.length}#{value}" }.join

    secret_word = 'ZbWt7rWB*wB!GT2Fu7Uje!9jXj&m&@-Cc2?TeHpA5U7HGdKS?qQst85Xg8Fq4*sn'

    args = {
      'empty-cart': '1',
      merchant: '251018994895',
      'product-additional-fields': "format:#{self.format},length:#{self.length}",
    }.merge(signable)

    signature = OpenSSL::HMAC.hexdigest("sha256", secret_word, concat)

    query_params = args.clone.merge({ 'return-url': CGI.escape(args[:'return-url']) }).to_a.map { |key, value| "#{key}=#{value}" }.join('&') + "&signature=#{signature}"

    checkout_url = "https://secure.2checkout.com/checkout/buy?#{query_params}"

    checkout_url
  end
end
