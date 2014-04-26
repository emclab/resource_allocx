# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :resource_allocx_man_power, :class => 'ResourceAllocx::ManPower' do
    user_id 1
    position_id 1
  end
end

