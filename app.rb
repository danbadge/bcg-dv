require 'sinatra'
require 'csv'

set :port, 8081
set :bind, '0.0.0.0'

get '/lines' do
  content_type :json

  lines = CSV.read('data/lines.csv', :headers => true)

  body = lines.map do |l| 
    {
      'id' => l['line_id'],
      'name' => l['line_name'],
    }
  end

  body.to_json
end