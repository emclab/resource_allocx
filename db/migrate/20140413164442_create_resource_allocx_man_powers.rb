class CreateResourceAllocxManPowers < ActiveRecord::Migration
  def change
    create_table :resource_allocx_man_powers do |t|

      t.integer   :user_id
      t.string    :position
      t.integer   :allocation_id

      t.timestamps
    end
  end
end
