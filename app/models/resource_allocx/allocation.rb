module ResourceAllocx
  class Allocation < ActiveRecord::Base
      
    attr_accessor :status_name, :active_noupdate, :last_updated_by_name, :detailed_resource_noupdate, :show_to_customer_noupdate
    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :status, :class_name => 'Commonx::MiscDefinition'

    validates :resource_string, :detailed_resource_category, :detailed_resource_id, :fort_token, :presence => true
    validates :resource_id, :last_updated_by_id, :detailed_resource_id, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
    validates :detailed_resource_id, :uniqueness => {:scope => [:resource_id, :resource_string, :detailed_resource_category, :active, :fort_token]}, :if => 'active == true'
    validate :dynamic_validate
    
    default_scope {where(fort_token: Thread.current[:fort_token])}
      
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate_' + detailed_resource_category, self.fort_token, 'resource_allocx') if detailed_resource_category.present?
      eval(wf) if wf.present?
    end
  end
  
end
