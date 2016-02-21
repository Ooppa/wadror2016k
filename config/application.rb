require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

ENV.update YAML.load_file('config/application.yml')[Rails.env] rescue {}

module Ratebeer
  class Application < Rails::Application
    config.autoload_paths += Dir["#{Rails.root}/lib"]
  end
end
