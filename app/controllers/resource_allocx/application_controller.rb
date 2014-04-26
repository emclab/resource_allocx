module ResourceAllocx
  class ApplicationController < ActionController::Base

    include Authentify::SessionsHelper
    include Authentify::AuthentifyUtility
    include Authentify::UsersHelper
    include Authentify::UserPrivilegeHelper
    include Commonx::CommonxHelper
    
    before_filter :require_signin
    before_filter :max_pagination
    before_filter :check_access_right 
    before_filter :load_session_variable, :only => [:new, :edit]  #for parent_record_id & parent_resource in check_access_right
    after_filter :delete_session_variable, :only => [:create, :update]  #for parent_record_id & parent_resource in check_access_right
    before_filter :view_in_config?
   
    protected
  
    def max_pagination
      @max_pagination = find_config_const('pagination').to_i
    end
    
    def view_in_config?
      @view_in_config = Authentify::AuthentifyUtility.load_view_in_config
    end

  end
end
