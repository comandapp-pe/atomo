class Order < ApplicationRecord
  belongs_to :product
  has_many_attached :assets

  alias_attribute :CUSTOMEREMAIL, :customer_email
end
