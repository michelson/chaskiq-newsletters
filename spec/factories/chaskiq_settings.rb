# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :chaskiq_setting, :class => 'Setting' do
    config "MyText"
    campaign nil
  end
end
