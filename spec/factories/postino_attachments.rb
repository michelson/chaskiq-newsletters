# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :chaskiq_attachment, :class => 'Chaskiq::Attachment' do
    image "MyString"
    content_type "MyString"
    size 1
    name "MyString"
    campaign nil
  end
end
