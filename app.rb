require 'sinatra'
require 'sinatra/param'
require 'csv'

set :port, 8081
set :bind, '0.0.0.0'

before do
  content_type :json
end

get '/lines' do
  param :timestamp, String, :required => true
  param :x, Integer, :required => true
  param :y, Integer, :required => true

  lines = CSV.read('data/lines.csv', :headers => true)

  body = lines.map { |l|
    {
      'id' => l['line_id'],
      'name' => l['line_name'],
    }
  }

  body.to_json
end
