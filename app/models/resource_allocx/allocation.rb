module ResourceAllocx
  class Allocation < ActiveRecord::Base
      
    default_scope {where(fort_token: Thread.current[:fort_token])}
    
    attr_accessor :status_name, :active_noupdate, :last_updated_by_name, :detailed_resource_noupdate
    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :status, :class_name => 'Commonx::MiscDefinition'

    validates :resource_id, :resource_string, :detailed_resource_category, :detailed_resource_id, :presence => {:message => I18n.t('Not blank')}
    validates :fort_token, :presence => true
    validates :resource_id, :detailed_resource_id, :presence => {:message => I18n.t('Not blank')}, :numericality => {:only_integer => true, :greater_than => 0}
    validates :detailed_resource_id, :uniqueness => {:scope => [:resource_id, :resource_string, :detailed_resource_category, :assigned_as, :active, :fort_token], message: I18n.t('Duplicate') }, :if => 'active && assigned_as.present?'
    validates :detailed_resource_id, :uniqueness => {:scope => [:resource_id, :resource_string, :detailed_resource_category, :active, :fort_token], message: I18n.t('Duplicate')}, :if => 'active && assigned_as.blank?'
    validate :dynamic_validate
          
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate_' + detailed_resource_category, self.fort_token, 'resource_allocx') if detailed_resource_category.present?
      eval(wf) if wf.present?
    end
  end
  
end
