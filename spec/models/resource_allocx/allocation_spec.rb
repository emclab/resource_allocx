require 'spec_helper'

module ResourceAllocx
  describe Allocation do
    it "should be OK" do
      manpower = FactoryGirl.build(:resource_allocx_man_power)
      c = FactoryGirl.build(:resource_allocx_allocation, :man_power => manpower)
      c.should be_valid
    end

    it "should reject nil name" do
      manpower = FactoryGirl.build(:resource_allocx_man_power)
      c = FactoryGirl.build(:resource_allocx_allocation, :name => nil, :man_power => manpower)
      c.should_not be_valid
    end

    it "should reject nil resource_category" do
      manpower = FactoryGirl.build(:resource_allocx_man_power)
      c = FactoryGirl.build(:resource_allocx_allocation, :resource_category => nil, :man_power => manpower)
      c.should_not be_valid
    end

    it "should reject nil resource_id" do
      manpower = FactoryGirl.build(:resource_allocx_man_power)
      c = FactoryGirl.build(:resource_allocx_allocation, :resource_id => nil, :man_power => manpower)
      c.should_not be_valid
    end
    
    it "should reject 0 resource_id" do
      manpower = FactoryGirl.build(:resource_allocx_man_power)
      c = FactoryGirl.build(:resource_allocx_allocation, :resource_id => 0, :man_power => manpower)
      c.should_not be_valid
    end

    it "should reject nil resource_string" do
      manpower = FactoryGirl.build(:resource_allocx_man_power)
      c = FactoryGirl.build(:resource_allocx_allocation, :resource_string => nil, :man_power => manpower)
      c.should_not be_valid
    end

  end
end

