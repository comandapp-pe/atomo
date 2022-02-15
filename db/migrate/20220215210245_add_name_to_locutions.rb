class AddNameToLocutions < ActiveRecord::Migration[6.1]
  def change
    add_column :locutions, :name, :string
  end
end
