# frozen_string_literal: true
module Chaskiq
  class BaseService
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::SanitizeHelper

    #include RoutingHelper
  end
end
