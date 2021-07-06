class Rename2checkoutCodeToCheckoutCodeInProducts < ActiveRecord::Migration[6.1]
  def change
    rename_column :products, :'2checkout_code', :checkout_code
  end
end
