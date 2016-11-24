require 'rails_helper'

module ResourceAllocx
  RSpec.describe AllocationsController, type: :controller do
    routes {ResourceAllocx::Engine.routes}
    before(:each) do
      expect(controller).to receive(:require_signin)
      expect(controller).to receive(:require_employee)
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      
    end
    
    before(:each) do
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      @role2 = FactoryGirl.create(:role_definition, :name => 'ceo', :manager_role_id => nil)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ur2 = FactoryGirl.create(:user_role, :role_definition_id => @role2.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      ul2 = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id, :user_id => 2)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      @u2 = FactoryGirl.create(:user, :user_levels => [ul2], :user_roles => [ur2], :name => 'name2', :login => 'login2', :email => 'email2@bb.com')
      @alloc_status = FactoryGirl.create(:commonx_misc_definition, 'for_which' => 'alloc_status', :name => 'available')
      FactoryGirl.create(:commonx_misc_definition, 'for_which' => 'alloc_status', :name => 'not available')
      FactoryGirl.create(:commonx_misc_definition, 'for_which' => 'alloc_status', :name => 'vacation')

      FactoryGirl.create(:engine_config, :engine_name => 'resource_allocx', :engine_version => nil, :argument_name => 'allocation_assigned_as_man_power', :argument_value => "Authentify::UsersHelper.return_users('create', params[:controller])")
      FactoryGirl.create(:engine_config, :engine_name => 'resource_allocx', :engine_version => nil, :argument_name => 'allocation_assigned_as_man_power', :argument_value => "team lead,workman,electricien")

      FactoryGirl.create(:engine_config, :engine_name => 'resource_allocx', :engine_version => nil, :argument_name => 'allocation_resource_heavy_machine', :argument_value => "Authentify::UsersHelper.return_users('create', params[:controller])")
      FactoryGirl.create(:engine_config, :engine_name => 'resource_allocx', :engine_version => nil, :argument_name => 'allocation_positions_heavy_machine', :argument_value => "machine1,machine2, machine3")
      
      session[:user_role_ids] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id).user_role_ids
    end
    
    render_views

    describe "GET 'index'" do
      it "returns resource allocations" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ResourceAllocx::Allocation.order('created_at DESC')")
        session[:user_id] = @u.id
        alloc1 = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :resource_id => 10, :resource_string => 'projectx/projects', :detailed_resource_category => 'man_power', :detailed_resource_id => @u.id)
        alloc2 = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :assigned_as => 'a new allocation', :resource_id => 10, :resource_string => 'projectx/projects', :detailed_resource_category => 'man_power', :detailed_resource_id => @u2.id)
        get 'index', {detailed_resource_category: 'man_power'}
        expect(assigns(:allocations)).to match_array([alloc1, alloc2])
      end
      
      it "should only return the allocation for a given detailed_resource_category (e.g project)" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ResourceAllocx::Allocation.order('created_at DESC')")
        session[:user_id] = @u.id
        alloc1 = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :resource_string => 'projectx/projects', :detailed_resource_id => @u.id)
        alloc2 = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :assigned_as => 'a new allocation', :detailed_resource_id => @u2.id)
        get 'index', {:resource_string => 'projectx/projects', detailed_resource_category: 'man_power'}
        expect(assigns(:allocations)).to match_array([])
      end
      
      it "should only return the allocation for a given resource_id (e.g project)" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ResourceAllocx::Allocation.order('created_at DESC')")
        session[:user_id] = @u.id
        alloc1 = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :resource_id => 100, :detailed_resource_id => @u.id)
        alloc2 = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :assigned_as => 'a new allocation', :detailed_resource_id => @u2.id)
        get 'index', {:resource_id => 100, detailed_resource_category: alloc1.detailed_resource_category}
        expect(assigns(:allocations)).to match_array([alloc1])
      end
      
      it "should only return the allocation for a given resource_id and resource_string" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ResourceAllocx::Allocation.order('created_at DESC')")
        session[:user_id] = @u.id
        alloc1 = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :resource_id => 100, :detailed_resource_id => @u.id)
        alloc2 = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :assigned_as => 'a new allocation', :resource_string => 'projectx/projects', :resource_id => 100, :detailed_resource_id => @u2.id)
        get 'index', {:resource_string => 'projectx/projects', :resource_id => 100, detailed_resource_category: alloc2.detailed_resource_category}
        expect(assigns(:allocations)).to match_array([alloc2])
      end
      
    end
  
    describe "GET 'new'" do
      it "bring up new page with allocation" do
        FactoryGirl.create(:user_access, :action => 'create', :resource => 'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1, :sql_code => "")
        session[:user_id] = @u.id
        get 'new' , {:detailed_resource_category => 'man_power' }
        expect(response).to be_success
        #assigns[:resourse_category].should eq('production')
      end

      it "bring up new page with allocation with man_power" do
        FactoryGirl.create(:user_access, :action => 'create', :resource => 'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
                                         :sql_code => "")
        session[:user_id] = @u.id
        #manpower1 = FactoryGirl.attributes_for(:resource_allocx_man_power)
        alloc = FactoryGirl.attributes_for(:resource_allocx_allocation, :status_id => @alloc_status.id, :resource_id => 100, :resource_string => 'projectx/projects')
        get 'new' , {:allocation => alloc, :detailed_resource_category => 'man_power'}
        expect(response).to be_success
        #assigns[:resourse_category].should eq('production')
      end


    end
  
    describe "GET 'create'" do
      it "should create new allocation because of proper right access" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
                                         :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:detailed_resource_category] = 'man_power'
        alloc = FactoryGirl.attributes_for(:resource_allocx_allocation, :status_id => @alloc_status.id, :detailed_resource_category => 'man_power', :resource_id => 100, :resource_string => 'projectx/projects')
        get 'create', {:allocation => alloc}
        expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end

      it "should create two new allocations because of different resources" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
                                         :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:detailed_resource_category] = 'man_power'
        alloc1 = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :resource_id => 99, :resource_string => 'projectx/xyz')
        alloc2 = FactoryGirl.attributes_for(:resource_allocx_allocation, :status_id => @alloc_status.id, :resource_id => 100, :resource_string => 'projectx/projects')
        get 'create', {:allocation => alloc2}
        expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end

      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:detailed_resource_category] = 'man_power'
        alloc = FactoryGirl.attributes_for(:resource_allocx_allocation, :status_id => @alloc_status.id, :resource_id => nil, :resource_string => 'projectx/projects')
        get 'create', {:allocation => alloc}
        expect(response).to render_template('new')
      end
    end
  
    describe "GET 'edit'" do
      it "returns edit page" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        alloc = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :resource_id => 100, :resource_string => 'projectx/projects')
        get 'edit', {:id => alloc.id}
        expect(response).to be_success
      end

    end
  
    describe "GET 'update'" do
      it "should return success and redirect" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        alloc = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :resource_id => 100)
        get 'update', {:id => alloc.id, :allocation => {:assigned_as => 'xyz'}}
        expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render edit with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        alloc = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :resource_id => 100)
        get 'update', {:id => alloc.id, :allocation => {:detailed_resource_id => 0}}
        expect(response).to render_template('edit')
      end
    end
  
    describe "GET 'show'" do
      it "returns http success" do
        FactoryGirl.create(:user_access, :action => 'show', :resource =>'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        engine = FactoryGirl.create(:sw_module_infox_module_info)
        alloc = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :resource_id => engine.id, :resource_string => 'sw_module_infox/module_infos')
        get 'show', {:id => alloc.id}
        expect(response).to be_success
      end
    end
    
    describe "Destroy" do
      it "should destroy" do
        user_access = FactoryGirl.create(:user_access, :action => 'destroy', :resource =>'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        engine = FactoryGirl.create(:sw_module_infox_module_info)
        alloc = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :resource_id => engine.id, :resource_string => 'sw_module_infox/module_infos')
        get 'destroy', {:id => alloc.id}
        expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Deleted!") 
      end
    end
    
    describe "Multi CSV" do
      it "should render multi csv view" do
        FactoryGirl.create(:user_access, :action => 'multi_csv', :resource =>'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        engine = FactoryGirl.create(:sw_module_infox_module_info)
        alloc = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :resource_id => engine.id, :resource_string => 'sw_module_infox/module_infos')
        get 'multi_csv', {}
        expect(response).to be_success
      end
    end

  end
end
