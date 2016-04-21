# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :commonx_log, :class => 'Commonx::Log' do
    log "MyText"
    resource_id 1
    resource_name "MyString"
    last_updated_by_id 1
    fort_token '123456789'
  end
end
