class CreateLocutions < ActiveRecord::Migration[6.1]
  def change
    create_table :locutions do |t|

      t.timestamps
    end
  end
end
