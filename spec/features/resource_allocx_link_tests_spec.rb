require 'rails_helper'

RSpec.describe "LinkTests", type: :request do
  describe "GET /resource_allocx_link_tests" do
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      FactoryGirl.create(:user_access, :action => 'index', :resource => 'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
                         :sql_code => 'ResourceAllocx::Allocation.all')
      FactoryGirl.create(:user_access, :action => 'create', :resource => 'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
                         :sql_code => nil)
      FactoryGirl.create(:user_access, :action => 'update', :resource => 'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
                         :sql_code => "")
      FactoryGirl.create(:user_access, :action => 'show', :resource => 'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
                         :sql_code => "")
      FactoryGirl.create(:engine_config, :engine_name => 'resource_allocx', :engine_version => nil, :argument_name => 'man_power_position',
                         :argument_value => "team lead, workman, electricien")
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur], :login => 'thistest', :password => 'password', :password_confirmation => 'password')
      @alloc_status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'alloc_status', :name => 'available')
      FactoryGirl.create(:commonx_misc_definition, 'for_which' => 'alloc_status', :name => 'not available')
      FactoryGirl.create(:commonx_misc_definition, 'for_which' => 'alloc_status', :name => 'vacation')
      
      config_entry = FactoryGirl.create(:engine_config, :engine_name => 'rails_app', :engine_version => nil, :argument_name => 'SESSION_TIMEOUT_MINUTES', :argument_value => 30)
      
      FactoryGirl.create(:engine_config, :engine_name => 'resource_allocx', :engine_version => nil, :argument_name => 'allocation_resource_man_power', :argument_value => "Authentify::UsersHelper.return_users('create', params[:controller])")
      FactoryGirl.create(:engine_config, :engine_name => 'resource_allocx', :engine_version => nil, :argument_name => 'allocation_positions_man_power', :argument_value => "team lead,workman,electricien")
      FactoryGirl.create(:engine_config, :engine_name => 'resource_allocx', :engine_version => nil, :argument_name => 'allocation_resource_heavy_machine', :argument_value => "Authentify::UsersHelper.return_users('create', params[:controller])")
      FactoryGirl.create(:engine_config, :engine_name => 'resource_allocx', :engine_version => nil, :argument_name => 'allocation_positions_heavy_machine', :argument_value => "machine1,machine2, machine3")
      
      @engine = FactoryGirl.create(:sw_module_infox_module_info)
      @alloc = FactoryGirl.create(:resource_allocx_allocation, assigned_as: 'a man power A', :status_id => @alloc_status.id, detailed_resource_category: 'man_power', :resource_id => @engine.id, :resource_string => 'sw_module_infox/module_infos', :last_updated_by_id => @u.id, :detailed_resource_id => @u.id)

      visit '/'
      #login
      fill_in "login", :with => @u.login
      fill_in "password", :with => 'password'
      click_button 'Login'
    end
    
    it "should display allocations index page" do
      FactoryGirl.create(:user_access, :action => 'destroy_' + @alloc.detailed_resource_category, :resource => 'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
                         :sql_code => "")
      visit resource_allocx.allocations_path(:detailed_resource_category => @alloc.detailed_resource_category)
      save_and_open_page
      expect(page).to have_content('Allocations')
      click_link @alloc.id
      expect(page).to have_content('Allocation Info')
      expect(page).to have_content('Delete')
      #click_link 'Delete' #there is a confirmation 
      #visit resource_allocx.allocations_path(:detailed_resource_category => @alloc.detailed_resource_category)
      #expect(page).not_to have_content('a man power A')
    end
    
    it "should work with links on index page" do
      visit resource_allocx.allocations_path(detailed_resource_category: 'man_power', resource_id: @engine.id, resource_string: 'sw_module_infox/module_infos')
      #save_and_open_page
      click_link 'New Allocation'
      visit resource_allocx.allocations_path(detailed_resource_category: 'man_power', resource_id: @engine.id, resource_string: 'sw_module_infox/module_infos')
      click_link @alloc.id.to_s
      visit resource_allocx.allocations_path(detailed_resource_category: 'man_power', resource_id: @engine.id, resource_string: 'sw_module_infox/module_infos')
      click_link 'Edit'
      #select('not available', from: 'allocation_status_id')
      fill_in 'allocation_description', :with => 'new new'
      click_button "Save"
      save_and_open_page
      #bad data
      visit resource_allocx.allocations_path(detailed_resource_category: 'man_power', resource_id: @engine.id, resource_string: 'sw_module_infox/module_infos')
      click_link 'Edit'
      select('', from: 'allocation_detailed_resource_id')
      click_button 'Save'
      save_and_open_page
    end
    
    it "should display new allocation page and save new" do
      visit resource_allocx.allocations_path(detailed_resource_category: 'man_power', resource_id: @engine.id, resource_string: 'sw_module_infox/module_infos')
      save_and_open_page
      click_link 'New Allocation'
      #save_and_open_page
      expect(page).to have_content('New Allocation')
      fill_in 'allocation_start_date' , :with => Date.today
      fill_in 'allocation_description', with: 'engineer position'
      select('vacation', from: 'allocation_status_id')
      select(@u.name, from: 'allocation_detailed_resource_id')
      #select('team lead', from: 'allocation_assigned_as')
      click_button 'Save'
      #save_and_open_page
      #bad data
      visit resource_allocx.new_allocation_path(detailed_resource_category: 'man_power', resource_id: @engine.id, resource_string: 'ext_construction_projectx/projects')
      fill_in 'allocation_start_date' , :with => Date.today
      fill_in 'allocation_description', with: 'a new description'
      select('vacation', from: 'allocation_status_id')
      select(@u.name, from: 'allocation_detailed_resource_id')
      #select('team lead', from: 'allocation_assigned_as')
      click_button 'Save'
      #save_and_open_page #do you see can't blank after position?
      visit resource_allocx.allocations_path(:detailed_resource_category => 'man_power')
      expect(page).to have_content('a new description')
      #save_and_open_page
    end
    
    it "should display edit allocation page" do
      visit resource_allocx.edit_allocation_path(@alloc)
      expect(page).to have_content('Edit Allocation')
      
    end
  end
end
