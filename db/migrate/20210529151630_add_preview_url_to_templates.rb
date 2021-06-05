class AddPreviewUrlToTemplates < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :preview_url, :string
  end
end
