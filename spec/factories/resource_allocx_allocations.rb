# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :resource_allocx_allocation, :class => 'ResourceAllocx::Allocation' do
    resource_id 1
    resource_string "MyString"
    detailed_resource_category "MyString"
    assigned_as "MyString"
    detailed_resource_id 1
    description "MyText"
    status_id 1
    start_date "2013-10-02"
    end_date "2013-10-02"
    last_updated_by_id 1
  end
end
