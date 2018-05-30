require 'sinatra'
require 'sinatra/param'
require './lib/lines_service.rb'

set :port, 8081
set :bind, '0.0.0.0'
set :raise_sinatra_param_exceptions, true
set :show_exceptions, false

before do
  content_type :json
end

get '/lines' do
  param :timestamp, String, :required => true
  param :x, Integer, :required => true
  param :y, Integer, :required => true

  LinesService.new
    .lines_in_position_at_time(params[:x], params[:y], params[:timestamp])
    .to_json
end

get '/lines/:name' do
  line_name = params[:name]

  delayed_line = LinesService.new.delay(line_name)

  return line_not_found(line_name) if delayed_line.nil?

  delayed_line.to_json
end

error Sinatra::Param::InvalidParameterError do
  invalid_parameter(env['sinatra.error'])
end

def line_not_found(line_name)
  status 404

  {:error => "The line '#{line_name}' could not be found"}.to_json
end

def invalid_parameter(sinatra_error)
  status 400

  message = sinatra_error.message

  if message.include?('Parameter is required')
    return {:error => "Parameter '#{sinatra_error.param}' is required"}.to_json
  end

  {:error => "#{message} for parameter '#{sinatra_error.param}'"}.to_json
end
