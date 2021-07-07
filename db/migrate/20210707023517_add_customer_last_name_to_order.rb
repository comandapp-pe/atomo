class AddCustomerLastNameToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :customer_last_name, :string
  end
end
