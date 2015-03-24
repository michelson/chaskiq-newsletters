require "csv"

module Chaskiq
  class CsvImporter

    def import(file_path)
      file = File.open(file_path)
      CSV.parse(file.read)
    end

  end
end
