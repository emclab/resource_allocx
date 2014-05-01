# This migration comes from authentify (originally 20121007213222)
class CreateSysModules < ActiveRecord::Migration
  def change
    create_table :authentify_sys_modules do |t|
      t.string :module_name
      t.string :module_group_name
      t.timestamps
      t.string :brief_note
      
    end
    
    add_index :authentify_sys_modules, :module_group_name
    add_index :authentify_sys_modules, :module_name
  end
end
