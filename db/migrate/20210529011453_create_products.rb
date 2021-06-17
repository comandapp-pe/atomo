class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.string :preview_url
      t.decimal :price

      t.timestamps
    end
  end
end
