# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_role, :class => 'Authentify::UserRole' do
    role_definition_id 1
    user_id 1
  end
end
