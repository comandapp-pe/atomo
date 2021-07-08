class AddEnabledToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :enabled, :boolean
  end
end
