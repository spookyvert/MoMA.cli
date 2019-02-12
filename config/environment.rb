require 'bundler'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'

ActiveRecord::Base.logger = Logger.new(STDOUT)

old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil
require_all 'app'
