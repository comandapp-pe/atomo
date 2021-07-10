class RenameCheckoutComissionToCheckoutCommissionInOrders < ActiveRecord::Migration[6.1]
  def change
    rename_column :orders, :checkout_comission, :checkout_commission
  end
end
