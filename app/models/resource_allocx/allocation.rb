module ResourceAllocx
  class Allocation < ActiveRecord::Base
      
      attr_accessible :resource_id, :resource_string, :resource_category, :name, :description, :start_date, :end_date, :status_id, 
                      :last_updated_by_id, :man_power_attributes, :as => :role_new
      attr_accessible :name, :description, :start_date, :end_date, :status_id, 
                      :last_updated_by_id, :man_power_attributes, :as => :role_update

    
      attr_accessor :status_name    

      belongs_to :last_updated_by, :class_name => 'Authentify::User'
      belongs_to :status, :class_name => 'Commonx::MiscDefinition'
      has_one :man_power,  :class_name => "ResourceAllocx::ManPower"
      accepts_nested_attributes_for :man_power  #, :allow_destroy => true
      
      validates_presence_of :resource_id, :resource_string, :resource_category, :name, :status_id, :last_updated_by_id, :start_date

  end
  
end
