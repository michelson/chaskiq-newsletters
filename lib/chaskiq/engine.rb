module Chaskiq
  class Engine < ::Rails::Engine
    isolate_namespace Chaskiq

    config.generators do |g|
      g.test_framework  :rspec
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.integration_tool :rspec
    end

    config.autoload_paths += Dir["#{config.root}/app/jobs"]

    config.action_mailer.delivery_method = :ses

    initializer "chaskiq_aws_setup", :after => :load_config_initializers, :group => :all do
      Chaskiq::Config.config_ses
      Chaskiq::Config.config_fog
    end
  end
end

