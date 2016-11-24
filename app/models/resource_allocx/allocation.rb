module ResourceAllocx
  class Allocation < ActiveRecord::Base
      
    attr_accessor :status_name, :active_noupdate, :last_updated_by_name, :detailed_resource_noupdate, :show_to_customer_noupdate

    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :status, :class_name => 'Commonx::MiscDefinition'

    validates :resource_string, :detailed_resource_category, :detailed_resource_id, :presence => true
    validates :resource_id, :last_updated_by_id, :detailed_resource_id, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
    validates :detailed_resource_id, :uniqueness => {:scope => [:resource_id, :resource_string, :detailed_resource_category, :active]}, :if => 'active == true'
    #validates :assigned_as, :uniqueness => {:scope => [:resource_id, :resource_string, :detailed_resource_category], :case_sensitive => false}, :if => 'assigned_as.present?'
    validate :dynamic_validate
      
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate_' + detailed_resource_category, 'resource_allocx') if detailed_resource_category.present?
      eval(wf) if wf.present?
    end
    
    #convert to csv
    def self.m_to_csv()
      CSV.generate do |csv|
        #header array
        #header = ['id', 'engine_name',  'created_at', 'updated_at', token]        
        #csv << header
        all.each.with_index() do |config, i|
          #assembly array for the row
          token = ProjectMiscDefinitionx::MiscDefinition.where('project_id = ? AND definition_category = ? ', config.resource_id, 'package_code').last.name
          csv << self.make_engine_row(config, i, token)
        end 
      end   
    end
    
    def self.make_engine_row(config, i, token)
      row = Array.new
      row << i
      row << SwModuleInfox::ModuleInfo.find_by_id(config.detailed_resource_id).name
      row << config.last_updated_by_id
      row << token.strip if token.present? #fort_token
      row << config.created_at
      row << config.updated_at

      
      return row
    end
  end
  
end
