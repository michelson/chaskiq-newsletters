# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :postino_campaign_template, :class => 'CampaignTemplate' do
    template nil
    campaign nil
  end
end
