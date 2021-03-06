ENV['SINATRA_ENV'] ||= "development"
#ENV['SINATRA_ACTIVESUPPORT_WARNING'] = false

require 'rack-flash'
require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
)

require_relative '../app/controllers/application_controller'
require_all 'app'
