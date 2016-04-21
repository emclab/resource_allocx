# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :role_definition, :class => 'Authentify::RoleDefinition' do
    name "sales"
    brief_note "role sales"
    manager_role_id 1
    last_updated_by_id 1
    fort_token '123456789'
  end
end
