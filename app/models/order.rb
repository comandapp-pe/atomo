# typed: false

class Order < ApplicationRecord
  extend T::Sig

  belongs_to :product

  sig {params(length: Integer).returns(Integer)}
  def self.quote(length)
    case length
    when 15
      20
    when 30
      30
    when 60
      40
    else 9999
    end
  end

  sig {returns(String)}
  def checkout_url
  end
end
