class AddCheckoutIdToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :checkout_id, :integer
  end
end
