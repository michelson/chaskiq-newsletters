# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :chaskiq_template, :class => 'Chaskiq::Template' do
    name "MyString"
    body "<p>this is the template</p>"
  end
end
