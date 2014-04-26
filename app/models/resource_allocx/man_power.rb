module ResourceAllocx
  class ManPower < ActiveRecord::Base

      attr_accessible :user_id, :position_id #, :as => :role_new
      attr_accessible :user_id, :position_id #, :as => :role_update
    
      attr_accessor :user
      
      belongs_to :user,  :class_name => 'Authentify::User'
      belongs_to :allocation, :class_name => "ResourceAllocx::Allocation"
         
      validates_presence_of :user_id, :position_id    


  end


end
