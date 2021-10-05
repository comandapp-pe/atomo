# typed: false
class Order < ApplicationRecord
  belongs_to :product

  alias_attribute :CUSTOMEREMAIL, :customer_email
end
