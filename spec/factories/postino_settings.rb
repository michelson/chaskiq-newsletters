# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :postino_setting, :class => 'Setting' do
    config "MyText"
    campaign nil
  end
end
