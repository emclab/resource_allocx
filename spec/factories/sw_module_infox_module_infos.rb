# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sw_module_infox_module_info, :class => 'SwModuleInfox::ModuleInfo' do
    name "MyString"
    category_id 1
    last_updated_by_id 1
    active true
    module_desp "MyText"
    api_spec "MyText"
    about_init "MyText"
    submitted_by_id 1
    about_workflow "MyText"
    about_onboard_data "MyText"
    about_model "MyText"
    about_controller "MyText"
    about_subaction "MyText"
    submit_date "2014-05-18"
    wf_state "MyString"
    about_log "MyText"
    about_view "MyText"
    about_misc_def 'misc def'
    fort_token '123456789'
  end
end
