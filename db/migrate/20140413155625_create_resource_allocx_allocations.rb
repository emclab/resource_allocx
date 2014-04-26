class CreateResourceAllocxAllocations < ActiveRecord::Migration
  def change
    create_table :resource_allocx_allocations do |t|
      t.integer   :resource_id
      t.string    :resource_string
      t.string    :resource_category
      t.string    :name
      t.text      :description
      t.datetime  :start_date
      t.datetime  :end_date
      t.integer   :status_id
      t.integer :last_updated_by_id
      
      t.timestamps
    end
  end
end
