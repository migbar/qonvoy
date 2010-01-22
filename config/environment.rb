# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem "haml",                               :version => "2.2.17"
  config.gem "authlogic",                          :version => '2.1.3'
  config.gem "oauth",                              :version => '0.3.6'
  config.gem "authlogic-oauth",                    :version => '1.0.8', :lib => "authlogic_oauth"
  config.gem "settingslogic",                      :version => '2.0.3'
  config.gem 'hoptoad_notifier',                   :version => '2.1.2'
  config.time_zone = 'UTC'
end