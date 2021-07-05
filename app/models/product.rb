# typed: strict
class Product < ApplicationRecord
  validates :name, presence: true
  validates :external_reference, presence: true
  validates :preview_url, presence: true

  # validate :preview_url_must_be_a_vimeo_video
  #
  # def preview_url_must_be_a_vimeo_video
  #   response = Faraday.head("https://vimeo.com/api/oembed.json?url=#{preview_url}")
  #
  #   puts response.status == 404
  #
  #   errors.add(:preview_url, 'must be a Vimeo URL')
  # end
end
