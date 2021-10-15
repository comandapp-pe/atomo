class Idea < ApplicationRecord
  belongs_to :order

  validates :content, presence: true, length: { maximum: 30 }
  validate :content_is_two_words_max

  def content_is_two_words_max
    return if content.blank?

    return if content.split.size <= 2

    errors.add(:content, 'puede ser dos palabras como máximo')
  end
end
