class RemovePriceInProducts < ActiveRecord::Migration[6.1]
  def change
    remove_column :products, :price
  end
end
