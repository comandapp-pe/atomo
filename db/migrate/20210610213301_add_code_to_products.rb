class AddCodeToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :code, :string, null: false
  end
end
