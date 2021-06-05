class RenameTemplatesToProducts < ActiveRecord::Migration[6.1]
  def change
    rename_table :products, :products
  end
end
