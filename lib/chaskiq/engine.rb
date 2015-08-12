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

    config.assets.precompile += %w(*.svg *.eot *.woff *.ttf *.gif *.png *.ico)
    config.assets.precompile += %w(chaskiq/manage/campaign_wizard.css chaskiq/iframe.js )
    config.assets.precompile += %w(font-awesome.css)
    initializer "chaskiq_setup", :after => :load_config_initializers, :group => :all do
      Chaskiq::Config.configure!
    end
  end
end

