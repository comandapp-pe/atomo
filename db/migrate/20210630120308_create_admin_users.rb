class CreateAdminUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_users do |t|
      t.string :tag, null: false
      t.string :password, null: false

      t.timestamps
    end
  end
end
