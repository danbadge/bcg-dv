require 'rack/test'
require 'rspec'
require 'json'

ENV['RACK_ENV'] = 'test'

require_relative '../app.rb'

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure { |c| c.include RSpecMixin }