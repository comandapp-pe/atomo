class Product < ApplicationRecord
  validates :name, presence: true, uniqueness: true, if: :persisted?
  validates :description, presence: true, if: :persisted?
  validates :published, inclusion: [true, false], if: :persisted?
  validates :category_id, presence: { message: 'Para publicar un producto, debes asignarle una categoría.' }, if: :published?

  before_validation :sync, on: :create

  belongs_to :category, optional: true

  def sync
    return errors.add(:vimeo_url, 'no puede estar en blanco') if vimeo_url.blank?

    return errors.add(:vimeo_url, "ya existe en otro producto") if Product.exists?(vimeo_url: vimeo_url)

    sync_vimeo

    return if errors.any?

    sync_checkout
  end

  def sync_vimeo
    response = Faraday.get("https://vimeo.com/api/oembed.json?url=#{self.vimeo_url}")

    return errors.add(:vimeo_url, 'no es una url válida') if response.status != 200

    body = JSON.parse(response.body).transform_keys(&:to_sym)

    # TODO: Add a failsafe in case Vimeo's API doesn't return what's expected

    self.name = body[:title]
    self.checkout_code = SecureRandom.alphanumeric(10)

    html = Nokogiri::HTML(body[:html])
    iframe = html.at('iframe')
    iframe['id'] = "preview-#{self.checkout_code}"
    self.preview_html = iframe.to_s

    self.description = body[:description].blank? ? 'Descripción por defecto.' : body[:description]
    self.thumbnail_url = body[:thumbnail_url]
    self.thumbnail_url_with_play_button = body[:thumbnail_url_with_play_button]
    self.published = false
  end

  def sync_checkout
    vendor_code = '251019015085'

    date = Time.now.utc.strftime '%Y-%m-%d %H:%M:%S'

    key = 'm&fsBk(ZxhMe)D%!|WqJ'

    data = vendor_code.length.to_s + vendor_code + date.length.to_s + date

    hash = OpenSSL::HMAC.hexdigest("md5", key, data)

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
                            }.to_json, {
                              'Content-Type': 'application/json',
                              'Accept': 'application/json',
                              'X-Avangate-Authentication': "code=\"#{vendor_code}\" date=\"#{date}\" hash=\"#{hash}\""
                            })

    return errors.add(:base, 'Ocurrió un error sincronizando con 2Checkout') if response.status != 201
  end
end