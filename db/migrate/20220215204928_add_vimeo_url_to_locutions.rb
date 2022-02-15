class AddVimeoUrlToLocutions < ActiveRecord::Migration[6.1]
  def change
    add_column :locutions, :vimeo_url, :string
  end
end
