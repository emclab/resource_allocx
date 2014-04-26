require 'spec_helper'

module ResourceAllocx
  describe Allocation do
    it "should be OK" do
      c = FactoryGirl.build(:resource_allocx_allocation)
      c.should be_valid
    end

    it "should reject nil name" do
      c = FactoryGirl.build(:resource_allocx_allocation, :name => nil)
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

    it "should reject nil resource_string" do
      c = FactoryGirl.build(:resource_allocx_allocation, :resource_string => nil)
      c.should_not be_valid
    end

  end
end

