module Chaskiq
  class List < ActiveRecord::Base
    has_many :subscriptions
    has_many :subscribers, through: :subscriptions
    has_many :campaigns

    accepts_nested_attributes_for :subscribers

    attr_accessor :upload_file

    def subscription_progress
      return 0 if subscribers.where(state: "subscribed").size.zero?
      (subscribers.where(state: "subscribed").size.to_f / subscribers.size.to_f  * 100.0).to_i
    end

    def import_csv(file)
      csv_importer.import(file).each do |row|
        puts "Importing row #{row}"
        sub = {email: row[0], name: row[1], last_name: row[2]}
        create_subscriber(sub)
      end
    end

    def create_subscriber(subscriber)
      sub = self.subscribers.find_or_initialize_by(email: subscriber[:email])
      sub.name = subscriber[:name]
      sub.last_name = subscriber[:last_name]
      s = self.subscriptions.find_or_initialize_by(id: sub.id)
      s.subscriber = sub
      s.save
      s.subscriber
    end

    def unsubscribe(subscriber)
      s = subscriptions.find_by(subscriber: subscriber)
      s.unsubscribe!
    end

    def subscribe(subscriber)
      s = subscriptions.find_by(subscriber: subscriber)
      s.subscribe!
    end

    def csv_importer
      @importer ||= Chaskiq::CsvImporter.new
    end

  end
end
