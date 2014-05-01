# This migration comes from authentify (originally 20130320042411)
class CreateAuthentifyRoleDefinitions < ActiveRecord::Migration
  def change
    create_table :authentify_role_definitions do |t|
      t.string :name
      t.string :brief_note
      t.integer :last_updated_by_id
      t.integer :manager_role_id

      t.timestamps
    end
    
    add_index :authentify_role_definitions, :manager_role_id
  end
end
