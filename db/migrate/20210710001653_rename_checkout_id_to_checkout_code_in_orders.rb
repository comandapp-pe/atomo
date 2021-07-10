class RenameCheckoutIdToCheckoutCodeInOrders < ActiveRecord::Migration[6.1]
  def change
    rename_column :orders, :checkout_id, :checkout_code
  end
end
