class RenameCodeToExternalReferenceInProducts < ActiveRecord::Migration[6.1]
  def change
    rename_column :products, :code, :external_reference
  end
end
