# This migration comes from authentify (originally 20130318014313)
class CreateAuthentifyUserRoles < ActiveRecord::Migration
  def change
    create_table :authentify_user_roles do |t|
      t.integer :last_updated_by_id
      t.integer :role_definition_id
      t.integer :user_id
      t.timestamps
      t.string  :brief_note
      
    end
    
    add_index :authentify_user_roles, :user_id
    add_index :authentify_user_roles, :role_definition_id
  end
end
