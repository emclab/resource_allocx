# This migration comes from commonx (originally 20130812014613)
class CreateCommonxLogs < ActiveRecord::Migration
  def change
    create_table :commonx_logs do |t|
      t.text :log
      t.integer :resource_id
      t.string :resource_name
      t.integer :last_updated_by_id

      t.timestamps
    end
    
    add_index :commonx_logs, :resource_id
    add_index :commonx_logs, :resource_name
    add_index :commonx_logs, [:resource_id, :resource_name]
  end
end
