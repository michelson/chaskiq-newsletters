require "postino/engine"
require "haml"
require "simple_form"
require "kaminari"
require "font-awesome-rails"
require "bootstrap-sass"
require "postino/engine"
require "urlcrypt"
require "cocoon"
require "mustache"

module Postino
  URLcrypt.key = 'postino123'
  autoload :VERSION, "postino/version"
  autoload :Config, "postino/config"
  autoload :CsvImporter, "postino/csv_importer"
  autoload :LinkRenamer, "postino/link_renamer"
end
