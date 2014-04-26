# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :resource_allocx_allocation, :class => 'ResourceAllocx::Allocation' do
    resource_id 1
    resource_string "MyString"
    resource_category "MyString"
    name "MyString"
    description "MyText"
    status_id 1
    start_date "2013-10-02 15:59:52"
    end_date "2013-10-02 15:59:52"
    last_updated_by_id 1
  end
end
