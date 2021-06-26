# typed: strict

require 'sorbet-runtime'

class Fruit < T::Enum
  extend T::Sig

  enums do
    BANANA = new('banana')
    APPLE = new('apple')
  end

  sig { params(value: Fruit).returns(T::Boolean) }
  def self.banana?(value)
    value == BANANA
  end
end

