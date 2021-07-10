class AddCheckoutComissionToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :checkout_comission, :decimal
  end
end
