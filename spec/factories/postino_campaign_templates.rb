# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :postino_campaign_template, :class => 'Postino::CampaignTemplate' do
    template nil
    campaign nil
  end
end
