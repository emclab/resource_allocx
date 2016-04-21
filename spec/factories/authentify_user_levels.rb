FactoryGirl.define do
  factory :user_level, class: 'Authentify::UserLevel'  do
    sys_user_group_id   1
    user_id 1
    fort_token '123456789'
  end
end