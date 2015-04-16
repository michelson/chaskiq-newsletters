module Chaskiq
  class ListImporterJob < ActiveJob::Base
    # Set the Queue as Default
    queue_as :default

    #send to all list with state passive & subscribed
    def perform(list, file)
      list.import_csv(file)
    end

  end
end