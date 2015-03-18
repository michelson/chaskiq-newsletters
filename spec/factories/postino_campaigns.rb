# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :postino_campaign, :class => 'Campaign' do
    subject "MyString"
    from_name "MyString"
    from_email "MyString"
    reply_email "MyString"
    plain_content "MyText"
    html_content "MyText"
    query_string "MyString"
    scheduled_at "2015-03-17 23:10:06"
    timezone "MyString"
    state "MyString"
    recipients_count 1
    sent false
    opens_count 1
    clicks_count 1
    parent nil
  end
end
