require 'chaskiq/engine'
require 'haml'
require 'simple_form'
require 'kaminari'
require 'font-awesome-rails'
require 'bootstrap-sass'
require 'chaskiq/engine'
require 'URLcrypt'
require 'cocoon'
require 'mustache'
require 'dotenv'
require 'carrierwave'
require 'coffee-rails'
require 'premailer'
require 'groupdate'
require 'chartkick'
require 'jquery-rails'
require 'deep_cloneable'
require 'aws/ses'
require 'ransack'
require 'active_importer'

Dotenv.load

module Chaskiq
  autoload :VERSION, 'chaskiq/version'
  autoload :Config, 'chaskiq/config'
  autoload :LinkRenamer, 'chaskiq/link_renamer'
end
