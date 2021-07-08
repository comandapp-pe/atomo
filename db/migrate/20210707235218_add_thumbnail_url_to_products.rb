class AddThumbnailUrlToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :thumbnail_url, :string
  end
end
