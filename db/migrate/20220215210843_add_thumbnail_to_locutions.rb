class AddThumbnailToLocutions < ActiveRecord::Migration[6.1]
  def change
    add_column :locutions, :thumbnail_url, :string
    add_column :locutions, :thumbnail_url_with_play_button, :string
    add_column :locutions, :published, :boolean
  end
end
