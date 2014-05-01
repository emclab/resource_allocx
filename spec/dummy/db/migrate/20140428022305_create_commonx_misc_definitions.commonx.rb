# This migration comes from commonx (originally 20130806021318)
class CreateCommonxMiscDefinitions < ActiveRecord::Migration
  def change
    create_table :commonx_misc_definitions do |t|
      t.string :name
      t.boolean :active, :default => true
      t.string :for_which
      t.text :brief_note
      t.integer :last_updated_by_id
      t.integer :ranking_index

      t.timestamps
    end
    
    add_index :commonx_misc_definitions, :for_which
    add_index :commonx_misc_definitions, :active
    add_index :commonx_misc_definitions, [:active, :for_which]
  end
end
