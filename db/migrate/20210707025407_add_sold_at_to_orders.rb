class AddSoldAtToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :sold_at, :datetime
  end
end
