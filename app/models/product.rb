# typed: strict
class Product < ApplicationRecord
  before_validation :sync

  # an unique check should be added for the vimeo url

  def sync
    sync_vimeo
    sync_checkout
  end

  def sync_vimeo
    response = Faraday.get(
      "https://vimeo.com/api/oembed.json?url=#{self.vimeo_url}",
      { 'Accept': 'application/json' }
    )

    if response.status == 404
      errors.add(:vimeo_url, 'no es una URL válida de Vimeo')

      return
    end

    body = JSON.parse(response.body).transform_keys { |key| key.to_sym }

    self.name = body[:title]
    self.preview_html = body[:html]
    self.description = body[:description]
    self.thumbnail_url_with_play_button = body[:thumbnail_url_with_play_button]
  end

  def sync_checkout
    vendor_code = '251019015085'

    date = Time.now.utc.strftime '%Y-%m-%d %H:%M:%S'

    key = 'm&fsBk(ZxhMe)D%!|WqJ'

    data = vendor_code.length.to_s + vendor_code + date.length.to_s + date

    hash = OpenSSL::HMAC.hexdigest("md5", key, data)

    self.checkout_code = SecureRandom.alphanumeric(10)

    response = Faraday.post('https://api.2checkout.com/rest/6.0/products',
                            {
                              "ProductCategory": "Audio & Video",
                              "ProductName": self.name,
                              "ProductCode": self.checkout_code,
                              "ProductType": "REGULAR",
                              "ProductVersion": "1.0",
                              "PurchaseMultipleUnits": false,
                              "ShortDescription": self.description,
                              "LongDescription": self.description,
                              "Enabled": true,
                              "GeneratesSubscription": false,
                              "Prices": [],
                              "PricingConfigurations": [
                                {
                                  "BillingCountries": [],
                                  "Default": true,
                                  "DefaultCurrency": "USD",
                                  "Name": "Default",
                                  "PriceType": "NET",
                                  "Prices": {
                                    "Regular": [
                                      {
                                        "Amount": 99,
                                        "Currency": "USD",
                                        "MaxQuantity": "99999",
                                        "MinQuantity": "1",
                                        "OptionCodes": []
                                      },
                                    ],
                                    "Renewal": []
                                  },
                                  "PricingSchema": "DYNAMIC"
                                }
                              ],
                              "AdditionalFields": [
                                {
                                  "Code": "Format",
                                  "Enabled": true,
                                  "Label": "Format",
                                  "Required": true,
                                },
                                {
                                  "Code": "Length",
                                  "Enabled": true,
                                  "Label": "Length",
                                  "Required": true,
                                }
                              ],
                            }
                              .to_json, {
                              'Content-Type': 'application/json',
                              'Accept': 'application/json',
                              'X-Avangate-Authentication': "code=\"#{vendor_code}\" date=\"#{date}\" hash=\"#{hash}\""
                            })

    if response.status != 201
      errors.add(:base, 'Ocurrió un error sincronizando con 2Checkout')

      return
    end
  end
end