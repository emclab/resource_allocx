require 'spec_helper'

module ResourceAllocx
  describe Allocation do
    it "should be OK" do
      c = FactoryGirl.build(:resource_allocx_allocation, :assigned_as => 'engineer')
      c.should be_valid
    end

    it "should reject nil assigned_as" do
      c = FactoryGirl.build(:resource_allocx_allocation, :assigned_as => nil)
      c.should_not be_valid
    end

    it "should reject nil resource_category" do
      c = FactoryGirl.build(:resource_allocx_allocation, :resource_category => nil)
      c.should_not be_valid
    end

    it "should reject nil resource_id" do
      c = FactoryGirl.build(:resource_allocx_allocation, :resource_id => nil)
      c.should_not be_valid
    end
    
    it "should reject 0 resource_id" do
      c = FactoryGirl.build(:resource_allocx_allocation, :resource_id => 0)
      c.should_not be_valid
    end

    it "should reject nil resource_string" do
      c = FactoryGirl.build(:resource_allocx_allocation, :resource_string => nil)
      c.should_not be_valid
    end

  end
end

