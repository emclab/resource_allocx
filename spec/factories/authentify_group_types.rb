# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group_type, :class => 'Authentify::GroupType' do
    name "employee"
    fort_token '123456789'
  end
end
