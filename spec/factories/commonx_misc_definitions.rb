# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :commonx_misc_definition, :class => 'Commonx::MiscDefinition' do
    name "MyString"
    active false
    for_which "task"
    brief_note "MyText"
    last_updated_by_id 1
    ranking_index 1
  end
end
