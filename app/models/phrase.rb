class Phrase < ApplicationRecord
  belongs_to :order

  validates :content, presence: true, length: { maximum: 80 }

  after_create_commit -> { broadcast_append_to(order, :phrases, target: 'all_phrases') }
  after_destroy_commit -> { broadcast_remove_to(order, :phrases) }
end
