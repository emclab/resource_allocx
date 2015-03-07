module ResourceAllocx
  class ApplicationController < ::ApplicationController

    include Authentify::SessionsHelper
    include Authentify::AuthentifyUtility
    include Authentify::UsersHelper
    include Authentify::UserPrivilegeHelper
    include Commonx::CommonxHelper
    
    before_action :require_signin
    before_action :set_locale
    before_action :max_pagination
    before_action :check_access_right 
    before_action :load_session_variable, :only => [:new, :edit]  #for parent_record_id & parent_resource in check_access_right
    after_action :delete_session_variable, :only => [:create, :update]  #for parent_record_id & parent_resource in check_access_right
    before_action :view_in_config?
   
    protected
  
    def max_pagination
      @max_pagination = find_config_const('pagination').to_i
    end
    
    def view_in_config?
      @view_in_config = Authentify::AuthentifyUtility.load_view_in_config
    end

  end
end
