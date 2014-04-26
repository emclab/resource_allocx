# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :zone, :class => 'Authentify::Zone' do
    zone_name "hq"
    brief_note "zone hq"
    active true
    ranking_order 1
  end
end
