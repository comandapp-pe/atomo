class AddAttrsToLocutions < ActiveRecord::Migration[6.1]
  def change
    add_column :locutions, :preview_html, :string
    add_column :locutions, :description, :string
  end
end
