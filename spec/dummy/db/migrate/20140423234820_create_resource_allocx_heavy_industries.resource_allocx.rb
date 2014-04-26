# This migration comes from resource_allocx (originally 20140413164503)
class CreateResourceAllocxHeavyIndustries < ActiveRecord::Migration
  def change
    create_table :resource_allocx_heavy_industries do |t|

      t.timestamps
    end
  end
end
