# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :postino_template, :class => 'Template' do
    name "MyString"
    body "MyText"
  end
end
