class AddPreviewUrlToTemplates < ActiveRecord::Migration[6.1]
  def change
    add_column :templates, :preview_url, :string
  end
end
