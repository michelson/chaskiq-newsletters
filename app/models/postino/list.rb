module Postino
  class List < ActiveRecord::Base
    has_many :subscribers
    has_many :campaigns

    def import_csv(file)
      csv_importer.import(file).each do |row|
        puts "Importing row #{row}"
        self.subscribers.create(email: row[0], name: row[1], last_name: row[2])
      end
    end

    def csv_importer
      @importer ||= Postino::CsvImporter.new
    end

  end
end
