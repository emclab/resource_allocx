# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sys_user_group, class: 'Authentify::SysUserGroup'  do
    user_group_name "my group name"
    group_type_id 1
    short_note "my group"
    zone_id 1
    fort_token '123456789'
  end
end
