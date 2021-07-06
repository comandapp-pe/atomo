class RenamePreviewUrlToPreviewHtmlInProducts < ActiveRecord::Migration[6.1]
  def change
    rename_column :products, :preview_url, :preview_html
  end
end
