require 'active_record'
require 'pg'
require 'helpers/db_helpers'

DbHelpers.ensure_database_exists
DbHelpers.establish_connection

RSpec.configure do |config|
  config.include DbHelpers

  # implements `use_transactional_fixtures = true`
  config.before(:each) do
    connection = ActiveRecord::Base.connection
    connection.begin_transaction(joinable: false)
  end

  config.after(:each) do
    connection = ActiveRecord::Base.connection
    connection.rollback_transaction if connection.transaction_open?
    ActiveRecord::Base.clear_active_connections!
  end
end
