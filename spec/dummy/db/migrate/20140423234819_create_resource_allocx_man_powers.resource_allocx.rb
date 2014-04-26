# This migration comes from resource_allocx (originally 20140413164442)
class CreateResourceAllocxManPowers < ActiveRecord::Migration
  def change
    create_table :resource_allocx_man_powers do |t|

      t.integer   :user_id
      t.integer   :position_id
      t.integer   :allocation_id

      t.timestamps
    end
  end
end
