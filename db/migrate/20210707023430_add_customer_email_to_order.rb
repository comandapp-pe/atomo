class AddCustomerEmailToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :customer_email, :string
  end
end
