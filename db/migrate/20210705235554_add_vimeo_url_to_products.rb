class AddVimeoUrlToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :vimeo_url, :string
  end
end
