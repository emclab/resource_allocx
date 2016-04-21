module ResourceAllocx
  class ApplicationController < ::ApplicationController

    include Authentify::SessionsHelper
    include Authentify::AuthentifyUtility
    include Authentify::UsersHelper
    include Authentify::UserPrivilegeHelper
    include Commonx::CommonxHelper
    
    before_action :require_signin
    before_action :max_pagination
    before_action :check_access_right 
    before_action :load_session_variable, :only => [:new, :edit]  #for parent_record_id & parent_resource in check_access_right
    after_action :delete_session_variable, :only => [:create, :update]  #for parent_record_id & parent_resource in check_access_right
    
    helper_method :return_users
    
    protected
  
    def max_pagination
      @max_pagination = find_config_const('pagination', session[:fort_token]).to_i
    end
    
    
  end
end
