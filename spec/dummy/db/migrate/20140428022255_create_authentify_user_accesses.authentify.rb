# This migration comes from authentify (originally 20130316154602)
class CreateAuthentifyUserAccesses < ActiveRecord::Migration
  def change
    create_table :authentify_user_accesses do |t|
      #t.string :right
      #t.integer :user_role_id
      t.string :action
      t.string :resource
      #t.string :resource_type
      t.string :brief_note
      t.integer :last_updated_by_id
      t.integer :role_definition_id
      t.text :sql_code
      t.text :masked_attrs
      t.integer :rank

      t.timestamps
    end
    
    add_index :authentify_user_accesses, :action
    add_index :authentify_user_accesses, :resource
    add_index :authentify_user_accesses, [:action, :resource]
    add_index :authentify_user_accesses, :role_definition_id
    add_index :authentify_user_accesses, :rank
  end
end
