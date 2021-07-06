# typed: strict
class Product < ApplicationRecord
  before_validation :sync

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
      errors.add(:vimeo_url, 'is not a valid Vimeo URL')

      return
    end

    json = JSON.parse(response.body).transform_keys { |key| key.to_sym }

    self.name = json[:title]
    self.preview_html = json[:html]
    self.description = json[:description]
    self.thumbnail_url_with_play_button = json[:thumbnail_url_with_play_button]
  end

  def sync_checkout
    self.checkout_code = 'XLR8'
  end
end
