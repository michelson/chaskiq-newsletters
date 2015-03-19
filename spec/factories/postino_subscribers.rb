# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :postino_subscriber, :class => 'Postino::Subscriber' do

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
