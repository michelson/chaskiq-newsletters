# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :chaskiq_list, :class => 'Chaskiq::List' do
    name "MyString"
    #state "MyString"
    #unsubscribe_count 1
    #bounced 1
    #active_count 1
  end
end
