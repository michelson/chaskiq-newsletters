module Postino
  class List < ActiveRecord::Base
    has_many :subscribers
    has_many :campaigns

    accepts_nested_attributes_for :subscribers

    def subscription_progress
      return 0 if subscribers.where(state: "subscribed").size.zero?
      (subscribers.where(state: "subscribed").size.to_f / subscribers.size.to_f  * 100.0).to_i
    end

    def import_csv(file)
      csv_importer.import(file).each do |row|
        puts "Importing row #{row}"
        sub = self.subscribers.find_or_initialize_by(email: row[0])
        sub.name = row[1]
        sub.last_name = row[2]
        sub.save
      end
    end

    def csv_importer
      @importer ||= Postino::CsvImporter.new
    end

  end
end
