# This migration comes from authentify (originally 20130113180408)
class CreateAuthentifyZones < ActiveRecord::Migration
  def change
    create_table :authentify_zones do |t|
      t.string :zone_name
      t.string :brief_note
      t.boolean :active, :default => true
      t.integer :ranking_order

      t.timestamps
    end
    
    add_index :authentify_zones, [:id, :active]
  end
end
