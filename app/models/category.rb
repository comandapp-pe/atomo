class Category < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true

  before_destroy :unpublish_associated_products

  has_many :products, dependent: :nullify

  def unpublish_associated_products
    self.products.update_all(published: false)
  end
end
