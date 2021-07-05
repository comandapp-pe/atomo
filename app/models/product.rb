# typed: strict
class Product < ApplicationRecord
  validates :name, presence: true
  validates :external_reference, presence: true
  validates :preview_url, url: true
end
