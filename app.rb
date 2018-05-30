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

  stop_ids = stop_ids_at_position(params[:x], params[:y])

  line_ids = line_ids_at_stops_and_time(stop_ids, params[:timestamp])

  lines_at_position_and_time = lines_in(line_ids).map { |line|
    {
      :id => line['line_id'],
      :name => line['line_name'],
    }
  }

  lines_at_position_and_time.to_json
end

def stop_ids_at_position(x, y)
  stops = CSV.read('data/stops.csv', :headers => true)

  nearby_stops = stops.select { |stop|
    stop['x'] == x.to_s && stop['y'] == y.to_s
  }

  nearby_stops.map { |stop|
    stop['stop_id']
  }
end

def line_ids_at_stops_and_time(stop_ids, timestamp)
  stop_times = CSV.read('data/stop_times.csv', :headers => true)

  stops_at_time_with_id = stop_times.select { |times|
    stop_ids.include?(times['stop_id']) && times['time'] == timestamp
  }

  stops_at_time_with_id.map { |times| times['line_id'] }
end

def lines_in(line_ids)
  all_lines = CSV.read('data/lines.csv', :headers => true)

  all_lines.select { |line| line_ids.include?(line['line_id']) }
end
