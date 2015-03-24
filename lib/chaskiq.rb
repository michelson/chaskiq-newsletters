require "chaskiq/engine"
require "haml"
require "simple_form"
require "kaminari"
require "font-awesome-rails"
require "bootstrap-sass"
require "chaskiq/engine"
require "urlcrypt"
require "cocoon"
require "mustache"
require 'dotenv'
require 'carrierwave'
require 'coffee-rails'
require 'premailer'
require 'groupdate'
require 'chartkick'

Dotenv.load

module Chaskiq
  URLcrypt.key = 'chaskiq123'
  autoload :VERSION, "chaskiq/version"
  autoload :Config, "chaskiq/config"
  autoload :CsvImporter, "chaskiq/csv_importer"
  autoload :LinkRenamer, "chaskiq/link_renamer"
end
