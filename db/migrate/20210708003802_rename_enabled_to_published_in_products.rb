class RenameEnabledToPublishedInProducts < ActiveRecord::Migration[6.1]
  def change
    rename_column :products, :enabled, :published
  end
end
