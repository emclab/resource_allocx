require 'spec_helper'

describe "LinkTests" do
  describe "GET /resource_allocx_link_tests" do
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      FactoryGirl.create(:user_access, :action => 'index', :resource => 'resource_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
                         :sql_code => nil)
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


      manpower1 = FactoryGirl.create(:resource_allocx_man_power, :user_id => @u.id)
      @alloc = FactoryGirl.create(:resource_allocx_allocation, :status_id => @alloc_status.id, :resource_id => 100, :last_updated_by_id => @u.id,
                                  :man_power => manpower1)

      visit '/'
      #login
      fill_in "login", :with => @u.login
      fill_in "password", :with => 'password'
      click_button 'Login'
    end
    
    it "should display allocations index page" do
      visit allocations_path
      page.body.should have_content('Allocations')
    end
    
    it "should work with links on index page" do
      visit allocations_path
      click_link 'New Allocation'
      visit allocations_path
      click_link @alloc.id.to_s
      visit allocations_path
      click_link 'Edit'
      save_and_open_page
    end
    
    it "should display new allocation page" do
      visit new_allocation_path
      page.body.should have_content('New Allocation')
      visit allocations_path
      save_and_open_page
    end
    
    it "should display edit allocation page" do
      visit edit_allocation_path(@alloc)
      page.body.should have_content('Edit Allocation')
      
    end
  end
end
