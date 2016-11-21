class CreateResourceAllocxAllocations < ActiveRecord::Migration
  def change
    create_table :resource_allocx_allocations do |t|
      t.integer   :resource_id
      t.string    :resource_string
      t.string    :detailed_resource_category
      t.string    :assigned_as  #for man power, like sales, project manager.
      t.integer   :detailed_resource_id
      t.text      :description
      t.datetime  :start_date
      t.datetime  :end_date
      t.integer   :status_id
      t.boolean   :active, :default => true
      t.integer   :last_updated_by_id
      t.timestamps
      t.boolean :show_to_customer
    end

    add_index :resource_allocx_allocations, [:resource_id, :resource_string], :name => 'alllocations_id_string'
    add_index :resource_allocx_allocations, :resource_id, :name => :resource_id_index
    add_index :resource_allocx_allocations, :resource_string, :name => :resource_string_index
    add_index :resource_allocx_allocations, :active, :name => :active_index
    add_index :resource_allocx_allocations, :detailed_resource_category, :name => 'res_category'
    add_index :resource_allocx_allocations, :detailed_resource_id, :name => 'detailed_res_id_index'
  end
end
