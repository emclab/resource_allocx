# This migration comes from sw_module_infox (originally 20140518141608)
class CreateSwModuleInfoxModuleInfos < ActiveRecord::Migration
  def change
    create_table :sw_module_infox_module_infos do |t|
      t.string :name
      t.string :version
      t.integer :category_id
      t.integer :last_updated_by_id
      t.boolean :active, :default => false
      t.text :module_desp
      t.text :api_spec
      t.text :about_init
      t.integer :submitted_by_id
      t.text :about_workflow
      t.text :about_onboard_data
      t.text :about_model
      t.text :about_controller
      t.text :about_subaction
      t.date :submit_date
      t.string :wf_state
      t.text :about_log
      t.text :about_view
      t.text :about_misc_def

      t.timestamps
      t.string :fort_token
    end
    
    add_index :sw_module_infox_module_infos, :category_id
    add_index :sw_module_infox_module_infos, :name
    add_index :sw_module_infox_module_infos, :wf_state
    add_index :sw_module_infox_module_infos, :active
    add_index :sw_module_infox_module_infos, :version
  end
end
