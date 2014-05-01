# This migration comes from commonx (originally 20130827231304)
class CreateCommonxSearchStatConfigs < ActiveRecord::Migration
  def change
    create_table :commonx_search_stat_configs do |t|
      t.string :resource_name
      t.text :stat_function
      t.text :stat_summary_function
      t.text :labels_and_fields
      t.string :time_frame
      t.string :search_list_form
      t.text :search_where
      t.text :search_results_period_limit
      t.integer :last_updated_by_id
      t.string :brief_note
      t.timestamps 
      t.string :stat_header
      t.text :search_params
      t.text :search_summary_function
    end
    
    add_index :commonx_search_stat_configs, :resource_name
  end
end
