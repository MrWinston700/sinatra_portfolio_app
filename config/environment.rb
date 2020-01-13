require 'bundler'
bundle.require

require_all 'app'

ActiveRecord::Base.establlish_connection(
    :adapter => "sqlite3", 
    :database => "db/development.sqlite"
)
