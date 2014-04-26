# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_access, :class => 'Authentify::UserAccess' do
    #right "allow"
    role_definition_id 1
    action "index"
    resource "Resource_Allocx::Allocations"
    #resource_type "table"
    sql_code ""
    masked_attrs ""
    rank 1
    brief_note "access rule"
  end
end
