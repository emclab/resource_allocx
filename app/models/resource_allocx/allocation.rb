module ResourceAllocx
  class Allocation < ActiveRecord::Base
      
    attr_accessor :status_name, :active_noupdate, :last_updated_by_name, :detailed_resource_noupdate
    attr_accessible :resource_id, :resource_string, :detailed_resource_category, :assigned_as, :description, :start_date, :end_date, :status_id,
                    :last_updated_by_id, :detailed_resource_id, :active,
                    :as => :role_new
    attr_accessible :assigned_as, :description, :start_date, :end_date, :status_id, :last_updated_by_id,
                    :detailed_resource_id, :active, :active_noupdate, :last_updated_by_name, :detailed_resource_noupdate,
                    :as => :role_update

    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :status, :class_name => 'Commonx::MiscDefinition'

    validates :resource_string, :detailed_resource_category, :detailed_resource_id, :presence => true
    validates :resource_id, :last_updated_by_id, :detailed_resource_id, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
    validates :detailed_resource_id, :uniqueness => {:scope => [:resource_id, :resource_string, :detailed_resource_category, :active]}, :if => 'active == true'
    validate :dynamic_validate
      
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate', 'resource_allocx')
      eval(wf) if wf.present?
    end
  end
  
end
