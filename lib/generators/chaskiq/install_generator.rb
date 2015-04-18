require 'securerandom'

module Chaskiq
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "Creates Chaskiq initializer, routes and copy locale files to your application."
      class_option :orm

      def copy_initializer
        #@underscored_user_name = "user".underscore
        template '../templates/chaskiq.rb.erb', 'config/initializers/chaskiq.rb'
      end

      def setup_routes
        route "mount Chaskiq::Engine => '/'"
      end

      #def self.source_root
      #  File.expand_path("../templates", __FILE__)
      #end

      def create_migrations
        exec 'bundle exec rake chaskiq:install:migrations'
        #Dir["#{self.class.source_root}/migrations/*.rb"].sort.each do |filepath|
        #  name = File.basename(filepath)
        #  template "migrations/#{name}", "db/migrate/#{name}"
        #  sleep 1
        #end
      end
    end
  end
end