# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :postino_subscriber, :class => 'Postino::Subscriber' do
    name "MyString"
    email "MyString"
    state "MyString"
    list nil
  end
end
