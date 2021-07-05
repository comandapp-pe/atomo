# typed: strict
class Product < ApplicationRecord
  validates :name, presence: true
  validates :external_reference, presence: true
  validates :preview_url, presence: true

  def preview_html
    response = Faraday.get("https://vimeo.com/api/oembed.json?url=#{preview_url}", {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    })

    if response.status == 404
      return nil
    end

    return JSON.parse response.body
  end
end
