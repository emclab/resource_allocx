# This migration comes from authentify (originally 20120608174504)
class CreateUserLevels < ActiveRecord::Migration
  def change
    create_table :authentify_user_levels do |t|
      t.integer :user_id
      t.integer :sys_user_group_id
      t.timestamps
      t.string  :brief_note
      t.string :fort_token
    end
    add_index :authentify_user_levels, :user_id
    add_index :authentify_user_levels, :sys_user_group_id
  end
end
