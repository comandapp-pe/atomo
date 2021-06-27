# typed: true
class CreateCheckoutLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :checkout_links do |t|
      t.references :product, null: false, foreign_key: true
      t.string :format, null: false
      t.integer :length, null: false

      t.timestamps
    end
  end
end
