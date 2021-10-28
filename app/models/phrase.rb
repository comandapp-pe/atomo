class Phrase < ApplicationRecord
  belongs_to :order

  validates :content, presence: true, length: { maximum: 80 }
end
