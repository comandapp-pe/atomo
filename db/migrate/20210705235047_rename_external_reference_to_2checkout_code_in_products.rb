class RenameExternalReferenceTo2checkoutCodeInProducts < ActiveRecord::Migration[6.1]
  def change
    rename_column :products, :external_reference, :'2checkout_code'
  end
end
