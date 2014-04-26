FactoryGirl.define do
  factory :user_level, class: 'Authentify::UserLevel'  do
    sys_user_group_id   1
    user_id 1
  end
end