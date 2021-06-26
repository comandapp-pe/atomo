# typed: true
class AddProductToOrders < ActiveRecord::Migration[6.1]
  def change
    add_reference :orders, :product, null: false, foreign_key: true
    add_column :orders, :format, :string, null: false
    add_column :orders, :length, :integer, null: false
    add_column :orders, :total, :decimal, null: false
    add_column :orders, :status, :integer, null: false
  end
end
