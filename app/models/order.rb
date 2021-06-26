# typed: strict

class Order < ApplicationRecord
  extend T::Sig

  sig {params(length: Integer).returns(Integer)}
  def self.quote(length)
    if length == 15
      20
    end

    if length == 30
      30
    end

    if length == 60
      40
    end

    20
  end
end
