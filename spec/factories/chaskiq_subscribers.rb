# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :chaskiq_subscriber, :class => 'Chaskiq::Subscriber' do

    sequence :email do |n|
      "person#{n}@example.com"
    end

    sequence :name do |n|
      "person #{n}"
    end

    sequence :last_name do |n|
      "#{n}son"
    end

  end
end
