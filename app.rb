require 'sinatra'
require 'sinatra/param'
require 'csv'

set :port, 8081
set :bind, '0.0.0.0'
set :raise_sinatra_param_exceptions, true

error Sinatra::Param::InvalidParameterError do
  status 400

  message = env['sinatra.error'].message

  if message.include?('Parameter is required')
    return {:error => "Parameter '#{env['sinatra.error'].param}' is required"}.to_json
  end

  {:error => "#{message} for parameter '#{env['sinatra.error'].param}'"}.to_json
end

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

get '/lines/:name' do
  lines = CSV.read('data/delays.csv', :headers => true)

  name = params[:name]

  delayed_line = lines.find { |line| line['line_name'] == name }

  return could_not_find_line_response(name) if delayed_line.nil?

  {
    :name => delayed_line['line_name'],
    :delay_in_minutes => delayed_line['delay'],
  }.to_json
end

def stop_ids_at_position(x, y)
  stops = CSV.read('data/stops.csv', :headers => true)

  stops_at_position = stops.select { |stop|
    stop['x'] == x.to_s && stop['y'] == y.to_s
  }

  stops_at_position.map { |stop|
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

def could_not_find_line_response(line_name)
  status 404

  {
    :error => "The line '#{line_name}' could not be found",
  }.to_json
end
