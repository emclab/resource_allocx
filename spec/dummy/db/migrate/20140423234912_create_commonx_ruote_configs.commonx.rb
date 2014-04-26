# This migration comes from commonx (originally 20131016012353)
class CreateCommonxRuoteConfigs < ActiveRecord::Migration
  def change
    create_table :commonx_ruote_configs do |t|
      t.string      :engine_name
      t.string      :engine_version
      t.string      :argument_name
      t.text        :argument_value
      t.integer     :last_updated_by_id
      t.string      :brief_note
      t.timestamps
      
    end
    
    add_index :commonx_ruote_configs, :engine_name
    add_index :commonx_ruote_configs, :argument_name
    add_index :commonx_ruote_configs, [:engine_name, :argument_name]
  end
end
