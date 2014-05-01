# This migration comes from authentify (originally 20121007213401)
class CreateSysModuleMappings < ActiveRecord::Migration
  def change
    create_table :authentify_sys_module_mappings do |t|
      t.integer :sys_module_id
      t.integer :sys_user_group_id
      t.timestamps
      t.string  :brief_note
      
    end
    
    add_index :authentify_sys_module_mappings, :sys_module_id
    add_index :authentify_sys_module_mappings, :sys_user_group_id
  end
end
