# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :chaskiq_subscription, :class => 'Subscription' do
    state "MyString"
    campaign nil
    subscriber nil
  end
end
