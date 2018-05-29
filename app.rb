require 'sinatra'

set :port, 8081
set :bind, '0.0.0.0'

get '/' do
  'Hello world!'
end