# typed: false
class Order < ApplicationRecord
  belongs_to :product

  def self.function
    1
  end
end
