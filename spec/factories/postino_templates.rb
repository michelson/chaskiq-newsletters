# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :postino_template, :class => 'Postino::Template' do
    name "MyString"
    body "<p>this is the template</p>"
  end
end
