class CreatePhrases < ActiveRecord::Migration[6.1]
  def change
    create_table :phrases do |t|

      t.timestamps
    end
  end
end
