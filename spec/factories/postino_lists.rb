# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :postino_list, :class => 'List' do
    name "MyString"
    state "MyString"
    unsubscribe_count 1
    bounced 1
    active_count 1
  end
end
