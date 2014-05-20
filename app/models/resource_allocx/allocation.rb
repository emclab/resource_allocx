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
      
      validates_presence_of :resource_string, :resource_category, :name, :start_date, :man_power
      validates :resource_id, :last_updated_by_id, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
      validate :validate_uniquess_position_per_resource

      def validate_uniquess_position_per_resource
        entries = ResourceAllocx::Allocation.where('resource_allocx_allocations.id <> ?', id).where(:resource_id => resource_id, :resource_string => resource_string).joins(:man_power).where(:resource_allocx_man_powers => {:position => man_power.position, :user_id => man_power.user_id}).all.size
        if entries > 0
          errors.add(man_power.position, I18n.t("Cannot assign the same user with same position on the same resource"))
        end
      end
  end
  
end
