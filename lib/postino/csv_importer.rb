require "csv"

module Postino
  class CsvImporter

    def import(file_path)
      file = File.open(file_path)
      CSV.parse(file.read)
    end

  end
end
