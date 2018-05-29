require 'spec_helper'

describe 'when making a request for the current lines' do
  context 'with a position' do
    before do
      get '/lines'
    end

    it 'returns 200 OK' do
      expect(last_response.status).to eq(200)
    end

    it 'returns all possible lines' do
      parsed_body = JSON.parse(last_response.body)
      expected = [
        { 'id' => '0', 'name' => 'M4' },
        { 'id' => '1', 'name' => '200' },
        { 'id' => '2', 'name' => 'S75' }
      ]
      expect(parsed_body).to eq(expected)
    end
  end
end