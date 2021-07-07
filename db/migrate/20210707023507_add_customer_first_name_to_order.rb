class AddCustomerFirstNameToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :customer_first_name, :string
  end
end
