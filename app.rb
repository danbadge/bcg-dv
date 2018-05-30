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

  nearby_stop_ids = stop_ids_at_coodinates(params[:x], params[:y])

  stop_times = CSV.read('data/stop_times.csv', :headers => true)
  stops_at_time_and_coordinates = stop_times.select { |times|
    nearby_stop_ids.include?(times['stop_id']) && times['time'] == params[:timestamp]
  }

  line_ids = stops_at_time_and_coordinates.map { |times| times['line_id'] }

  all_lines = CSV.read('data/lines.csv', :headers => true)

  lines = all_lines.select { |line| line_ids.include?(line['line_id']) }

  body = lines.map { |line|
    {
      :id => line['line_id'],
      :name => line['line_name'],
    }
  }

  body.to_json
end

def stop_ids_at_coodinates(x, y)
  stops = CSV.read('data/stops.csv', :headers => true)

  nearby_stops = stops.select { |stop|
    stop['x'] == x.to_s && stop['y'] == y.to_s
  }

  nearby_stops.map { |stop|
    stop['stop_id']
  }
end
