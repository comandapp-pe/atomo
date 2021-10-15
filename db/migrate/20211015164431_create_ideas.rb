class CreateIdeas < ActiveRecord::Migration[6.1]
  def change
    create_table :ideas do |t|
      t.references :order, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
