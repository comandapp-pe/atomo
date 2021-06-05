class CreateTemplates < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
