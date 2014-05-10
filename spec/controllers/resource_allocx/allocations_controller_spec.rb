require 'spec_helper'

module ResourceAllocx
  describe AllocationsController do
    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      
    end
    
    before(:each) do
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      @alloc_status = FactoryGirl.create(:commonx_misc_definition, 'for_which' => 'alloc_status', :name => 'available')
      FactoryGirl.create(:commonx_misc_definition, 'for_which' => 'alloc_status', :name => 'not available')
      FactoryGirl.create(:commonx_misc_definition, 'for_which' => 'alloc_status', :name => 'vacation')

    end
    
    render_views
    
    describe "GET 'index'" do
      it "returns resource allocations" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ResourceAllocx::Allocation.order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        manpower1 = FactoryGirl.create(:resource_allocx_man_power)
        manpower2 = FactoryGirl.create(:resource_allocx_man_power, :position => 'manager')
        alloc1 = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :resource_id => 10, :resource_string => 'projectx/projects', :resource_category => 'man_power', :man_power => manpower1)
        alloc2 = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :name => 'a new allocation', :resource_id => 10, :resource_string => 'projectx/projects', :resource_category => 'man_power', :man_power => manpower2)
        get 'index', {:use_route => :resource_allocx}
        assigns(:allocations).should =~ [alloc1, alloc2]
      end
      
      it "should only return the allocation for a given resource_string (e.g project)" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ResourceAllocx::Allocation.order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        alloc1 = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :resource_string => 'projectx/projects')
        alloc2 = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :name => 'a new allocation')
        get 'index', {:use_route => :resource_allocx, :resource_string => 'projectx/projects'}
        assigns(:allocations).should =~ [alloc1]
      end
      
      it "should only return the allocation for a given resource_id (e.g project)" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ResourceAllocx::Allocation.order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        alloc1 = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :resource_id => 100)
        alloc2 = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :name => 'a new allocation')
        get 'index', {:use_route => :resource_allocx, :resource_id => 100}
        assigns(:allocations).should =~ [alloc1]
      end
      
      it "should only return the allocation for a given resource_id and resource_string" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ResourceAllocx::Allocation.order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        alloc1 = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :resource_id => 100)
        alloc2 = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :name => 'a new allocation', :resource_string => 'projectx/projects', :resource_id => 100)
        get 'index', {:use_route => :resource_allocx, :resource_string => 'projectx/projects', :resource_id => 100}
        assigns(:allocations).should =~ [alloc2]
      end
      
    end
  
    describe "GET 'new'" do
      it "bring up new page with allocation" do
        FactoryGirl.create(:user_access, :action => 'create', :resource => 'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1, :sql_code => "")
        FactoryGirl.create(:engine_config, :engine_name => 'resource_allocx', :engine_version => nil, :argument_name => 'man_power_position', :argument_value => "'team lead', 'workman', 'electricien'")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new' , {:use_route => :resource_allocx}
        response.should be_success
        #assigns[:resourse_category].should eq('production')
      end

      it "bring up new page with allocation with man_power" do
        FactoryGirl.create(:user_access, :action => 'create', :resource => 'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
                                         :sql_code => "")
        FactoryGirl.create(:engine_config, :engine_name => 'resource_allocx', :engine_version => nil, :argument_name => 'man_power_position', :argument_value => "'team lead', 'workman', 'electricien'")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        manpower1 = FactoryGirl.attributes_for(:resource_allocx_man_power)
        alloc = FactoryGirl.attributes_for(:resource_allocx_allocation, :status_id => @alloc_status.id, :resource_id => 100, :resource_string => 'projectx/projects', :man_power => manpower1)
        get 'new' , {:use_route => :resource_allocx, :allocation => alloc}
        response.should be_success
        #assigns[:resourse_category].should eq('production')
      end


    end
  
    describe "GET 'create'" do
      it "should create new allocation because of proper right access" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
                                         :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        manpower = FactoryGirl.attributes_for(:resource_allocx_man_power)
        alloc = FactoryGirl.attributes_for(:resource_allocx_allocation, :status_id => @alloc_status.id, :resource_id => 100, :resource_string => 'projectx/projects', :man_power_attributes => manpower)
        get 'create', {:use_route => :resource_allocx, :allocation => alloc}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end

      it "should render 'new' if data error" do        
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        alloc = FactoryGirl.attributes_for(:resource_allocx_allocation, :status_id => @alloc_status.id, :resource_id => nil, :resource_string => 'projectx/projects')
        get 'create', {:use_route => :resource_allocx, :allocation => alloc}
        response.should render_template('new')
      end
    end
  
    describe "GET 'edit'" do
      it "returns edit page" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        alloc = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :resource_id => 100, :resource_string => 'projectx/projects')
        get 'edit', {:use_route => :resource_allocx, :id => alloc.id}
        response.should be_success
      end

    end
  
    describe "GET 'update'" do
      it "should return success and redirect" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        alloc = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :resource_id => 100)
        get 'update', {:use_route => :resource_allocx, :id => alloc.id, :allocation => {:name => 'new name'}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render edit with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        alloc = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :resource_id => 100)
        get 'update', {:use_route => :resource_allocx, :id => alloc.id, :allocation => {:name => ''}}
        response.should render_template('edit')
      end
    end
  
    describe "GET 'show'" do
      it "returns http success" do
        FactoryGirl.create(:user_access, :action => 'show', :resource =>'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        manpower1 = FactoryGirl.create(:resource_allocx_man_power, :user_id => @u.id)
        alloc = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :resource_id => 100, :man_power => manpower1)
        get 'show', {:use_route => :resource_allocx, :id => alloc.id}
        response.should be_success
      end
    end

  end
end
