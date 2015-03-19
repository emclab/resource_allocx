require 'rails_helper'

module ResourceAllocx
  RSpec.describe Allocation, type: :model do
    it "should be OK" do
      c = FactoryGirl.build(:resource_allocx_allocation, :assigned_as => 'engineer')
      expect(c).to be_valid
    end

    it "should take nil assigned_as" do
      c = FactoryGirl.build(:resource_allocx_allocation, :assigned_as => nil)
      expect(c).to be_valid
    end

    it "should reject nil resource_category" do
      c = FactoryGirl.build(:resource_allocx_allocation, :detailed_resource_category => nil)
      expect(c).not_to be_valid
    end

    it "should reject nil resource_id" do
      c = FactoryGirl.build(:resource_allocx_allocation, :resource_id => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject 0 resource_id" do
      c = FactoryGirl.build(:resource_allocx_allocation, :resource_id => 0)
      expect(c).not_to be_valid
    end

    it "should reject nil resource_string" do
      c = FactoryGirl.build(:resource_allocx_allocation, :resource_string => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject dup detailed resource id for the same resource id/string, category when allocation is active" do
      c1 = FactoryGirl.create(:resource_allocx_allocation, :active => true)
      c = FactoryGirl.build(:resource_allocx_allocation, :active => true)
      expect(c).not_to be_valid
    end
    
    it "should take dup detailed resource id for the different resource id/string with the same category when allocation is active" do
      c1 = FactoryGirl.create(:resource_allocx_allocation, :active => true)
      c = FactoryGirl.build(:resource_allocx_allocation, :active => true, :resource_id => c1.resource_id + 1)
      expect(c).to be_valid
    end
    
    it "should not take duplicate assigned_as for the same resource" do
      c1 = FactoryGirl.create(:resource_allocx_allocation, :assigned_as => 'true')
      c = FactoryGirl.build(:resource_allocx_allocation, :assigned_as => 'True', detailed_resource_id: c1.detailed_resource_id + 1)
      expect(c).to be_valid
    end

  end
end

