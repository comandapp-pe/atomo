class AddThumbnailUrlWithPlayButtonInProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :thumbnail_url_with_play_button, :string
  end
end
