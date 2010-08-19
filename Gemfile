source :gemcutter
# bundler requires these gems in all environments

# gem "geokit"
gem "rails", "~> 2.3.8"
gem "activerecord-jdbcmysql-adapter"
gem "jdbc-mysql"
gem "haml", "~> 3.0.0"
gem "bundler"
gem "authlogic", "2.1.3"
gem "oauth", "0.3.6"
gem "authlogic-oauth", :require => "authlogic_oauth", :git => "http://github.com/jrallison/authlogic_oauth.git"
gem "settingslogic", "2.0.3"
gem "formtastic", "0.9.7"
gem "acts-as-taggable-on", "2.0.6"
gem "hoptoad_notifier", "~> 2.2.0"
gem "twitter", "0.8.4"
gem "delayed_job", "~> 2.0.0"
gem "searchlogic", "2.4.14"
gem "geokit", "1.5.0"
# gem "json"
gem "json-jruby", ">= 1.4.1"
gem "rest-client", "1.6.0"
gem "jruby-openssl" 
gem "nokogiri", "1.4.3.1"
gem "neo4j", "0.4.5"

group :development do
  # bundler requires these gems in development
  # gem "rails-footnotes"
	gem "mongrel", :require => false
	gem "annotate", :require => false
	gem "launchy", :require => false
end

group :test do
  # bundler requires these gems while running tests
  # gem "faker"
  gem "remarkable_rails"
	gem "jasmine"
end

group :cucumber do
  gem "term-ansicolor"
  gem "cucumber-rails", :require => false
  gem "database_cleaner"
  gem "pickle"
  gem "capybara", :require => false
	# gem "thin"
	gem "selenium-webdriver", "0.0.23"
	
end

group :cucumber, :test do
  gem "factory_girl", :require => false
  gem "rspec-rails"
	gem "rspec"
	gem "webmock", "1.3.4"
end