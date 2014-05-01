# This migration comes from authentify (originally 20121007213119)
class CreateSysUserGroups < ActiveRecord::Migration
  def change
    create_table :authentify_sys_user_groups do |t|
      t.string :user_group_name
      t.string :short_note
      #t.integer :user_type_code  # 1 - employee, 2 - customer, etc
      #t.string :user_type_desp   #employee, customer, etc.
      t.integer :zone_id    #user location. ex, hq - head quarter.
      t.integer :group_type_id
      t.integer :manager_group_id
        
      t.timestamps
    end
    
    add_index :authentify_sys_user_groups, :zone_id
    add_index :authentify_sys_user_groups, :group_type_id
    add_index :authentify_sys_user_groups, :manager_group_id
  end
end
