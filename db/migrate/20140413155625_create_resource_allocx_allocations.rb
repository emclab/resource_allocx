class CreateResourceAllocxAllocations < ActiveRecord::Migration
  def change
    create_table :resource_allocx_allocations do |t|
      t.integer   :resource_id
      t.string    :resource_string
      t.string    :detailed_resource_category
      t.string    :assigned_as  #for man power, like sales, project manager.
      t.integer   :detailed_resource_id #from which the resource is allocated. For ex, Authentify::User, InfoServiceModulex::Module
      t.text      :description
      t.datetime  :start_date
      t.datetime  :end_date
      t.integer   :status_id
      t.boolean   :active, :default => true
      t.integer   :last_updated_by_id
      t.timestamps
      t.boolean :show_to_customer
      t.string :fort_token
    end

    add_index :resource_allocx_allocations, [:resource_id, :resource_string], :name => 'res_allocx_alllocations_id_string'
    add_index :resource_allocx_allocations, :resource_id
    add_index :resource_allocx_allocations, :resource_string
    add_index :resource_allocx_allocations, :active
    add_index :resource_allocx_allocations, :detailed_resource_category, :name => 'res_category'
    add_index :resource_allocx_allocations, :detailed_resource_id, :name => 'res_allocx_detailed_res_id'
    add_index :resource_allocx_allocations, :fort_token
  end
end
