module ResourceAllocx
  class Allocation < ActiveRecord::Base
      
      attr_accessor :status_name, :active_noupdate, :last_updated_by_name
      attr_accessible :resource_id, :resource_string, :resource_category, :assigned_as, :description, :start_date, :end_date, :status_id,
                      :last_updated_by_id, :detailed_resource_id, :active,
                      :as => :role_new
      attr_accessible :assigned_as, :description, :start_date, :end_date, :status_id, :last_updated_by_id,
                      :detailed_resource_id, :active, :active_noupdate, :last_updated_by_name,
                      :as => :role_update

    
      belongs_to :last_updated_by, :class_name => 'Authentify::User'
      belongs_to :status, :class_name => 'Commonx::MiscDefinition'

      validates_presence_of :resource_string, :resource_category, :assigned_as, :detailed_resource_id, :start_date
      validates :resource_id, :last_updated_by_id, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}

  end
  
end
