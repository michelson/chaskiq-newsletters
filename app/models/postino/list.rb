module Postino
  class List < ActiveRecord::Base
    has_many :subscribers
    has_many :campaigns

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
