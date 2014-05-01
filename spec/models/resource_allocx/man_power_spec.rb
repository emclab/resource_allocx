require 'spec_helper'

module ResourceAllocx
  describe ManPower do
    it "should be OK" do
      i = FactoryGirl.build(:resource_allocx_man_power)
      i.should be_valid
    end

    it "should reject nil position" do
      i = FactoryGirl.build(:resource_allocx_man_power, :position => nil)
      i.should_not be_valid
    end

    it "should reject nil user" do
      i = FactoryGirl.build(:resource_allocx_man_power, :user_id => nil)
      i.should_not be_valid
    end

  end

end
