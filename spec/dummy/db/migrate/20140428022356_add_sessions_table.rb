class AddSessionsTable < ActiveRecord::Migration
  def change
    create_table :authentify_sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end

    add_index :authentify_sessions, :session_id
    add_index :authentify_sessions, :updated_at
  end
end
