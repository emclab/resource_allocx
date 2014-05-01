# This migration comes from authentify (originally 20130121221405)
class CreateAuthentifyGroupTypes < ActiveRecord::Migration
  def change
    create_table :authentify_group_types do |t|
      t.string :name
      t.timestamps
      t.string :brief_note
      
    end
  end
end
