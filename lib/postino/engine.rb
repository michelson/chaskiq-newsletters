module Chaskiq
  class Engine < ::Rails::Engine
    isolate_namespace Chaskiq

    config.generators do |g|
      g.test_framework  :rspec
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.integration_tool :rspec
    end

  end
end

