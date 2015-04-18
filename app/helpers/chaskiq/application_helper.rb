module Chaskiq
  module ApplicationHelper

    def paginate objects, options = {}
      options.reverse_merge!( theme: 'twitter-bootstrap-3' )
      super( objects, options )
    end
  end

end
