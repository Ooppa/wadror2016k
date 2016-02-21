require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module Ratebeer
  class Application < Rails::Application
    config.autoload_paths += Dir["#{Rails.root}/lib"]
  end
end
