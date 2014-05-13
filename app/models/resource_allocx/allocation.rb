module ResourceAllocx
  class Allocation < ActiveRecord::Base
      
      attr_accessor :status_name, :active_noupdate, :last_updated_by_name
      attr_accessible :resource_id, :resource_string, :resource_category, :name, :description, :start_date, :end_date, :status_id, 
                      :last_updated_by_id, :man_power_attributes, :active, 
                      :as => :role_new
      attr_accessible :name, :description, :start_date, :end_date, :status_id, :last_updated_by_id, :man_power_attributes, :active, 
                      :active_noupdate, :last_updated_by_name,
                      :as => :role_update

    
      belongs_to :last_updated_by, :class_name => 'Authentify::User'
      belongs_to :status, :class_name => 'Commonx::MiscDefinition'
      has_one :man_power,  :class_name => "ResourceAllocx::ManPower"
      accepts_nested_attributes_for :man_power  #, :allow_destroy => true
      
      validates_presence_of :resource_string, :resource_category, :name, :start_date
      validates :resource_id, :last_updated_by_id, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
  end
  
end
