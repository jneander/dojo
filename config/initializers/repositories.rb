require 'dojo/repositories/repository'

case ENV['RAILS_ENV']
when 'test'
  Dojo::Repository.use( :memory )
when 'production'
  Dojo::Repository.use( :hyperion )
  connection_url = ENV['DATABASE_URL']
  Hyperion.datastore = 
    Hyperion.new_datastore( :postgres, connection_url: connection_url )
when 'development'
  Dojo::Repository.use( :hyperion )
  connection_url = 'postgres://localhost/dojo'
  Hyperion.datastore = 
    Hyperion.new_datastore( :postgres, connection_url: connection_url )
else
  Dojo::Repository.use( :memory )
end
