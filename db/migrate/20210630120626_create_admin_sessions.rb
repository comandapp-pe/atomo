class CreateAdminSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_sessions do |t|
      t.references :admin_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
