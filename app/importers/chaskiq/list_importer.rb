module Chaskiq
  class ListImporter < ActiveImporter::Base
    imports Subscriber

    column 'email', :email
    column 'name', :name

    on :row_processing do
      [row.keys - columns.keys].flatten.each do |k|
        model.options[k.gsub(" ", "-").underscore ] = row[k] 
      end
    end

    on :import_started do
      @list = Chaskiq::List.find(params[:list_id])
      @row_count = 0
    end

    on :row_processed do
      model.subscriptions.create(list: @list) if model.errors.blank?
      @row_count += 1
    end

    on :row_error do |err| 
      send_notification("Data imported successfully!")
    end

    on :import_finished do
      send_notification("Data imported successfully!")
    end

    on :import_failed do |exception|
      send_notification("Fatal error while importing data: #{exception.message}")
    end

  private

    def send_notification(message)
      puts message
    end

  end
end