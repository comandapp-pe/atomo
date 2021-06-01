class AddPriceToTemplate < ActiveRecord::Migration[6.1]
  def change
    add_column :templates, :price, :decimal, precision: 10, scale: 2
  end
end
