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
      t.boolean :active, :default => true
      t.integer :last_updated_by_id
      
      t.timestamps
    end

    add_index :resource_allocx_allocations, [:resource_id, :resource_string], :name => 'res_allocx_alllocations_id_string'
    add_index :resource_allocx_allocations, :resource_id
    add_index :resource_allocx_allocations, :resource_string
    add_index :resource_allocx_allocations, :status_id
    add_index :resource_allocx_allocations, :resource_category
  end
end
