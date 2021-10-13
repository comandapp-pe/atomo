class Order < ApplicationRecord
  belongs_to :product

  has_many_attached :assets

  validates :assets, blob: { content_type: 'video/mp4' }

  alias_attribute :CUSTOMEREMAIL, :customer_email
end
