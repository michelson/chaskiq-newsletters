# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :postino_metric, :class => 'Metric' do
    trackable nil
  end
end
