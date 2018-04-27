# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :chaskiq_metric, :class => 'Chaskiq::Metric' do
    trackable nil
  end
end
