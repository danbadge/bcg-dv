require 'spec_helper'

describe '~/lines' do
  let(:timestamp) { '10:00:00' }
  let(:x_coordinate) { '2' }
  let(:y_coordinate) { '4' }

  before do
    get '/lines', :timestamp => timestamp, :x => x_coordinate, :y => y_coordinate
  end

  context 'when making a request without timestamp' do
    let(:timestamp) { nil }

    it 'returns 400 bad request' do
      expect(last_response.status).to eq(400)
    end

    it 'returns a helpful JSON error message' do
      parsed_body = JSON.parse(last_response.body)
      expected = { 
        'errors' => { 'timestamp' => 'Parameter is required' },
        'message' => 'Parameter is required'
      }
      expect(parsed_body).to eq(expected)
    end
  end

  describe 'given the x coordinate parameter is invalid' do
    context 'when the x coordinate is missing' do
      let(:x_coordinate) { nil }

      it 'returns 400 bad request' do
        expect(last_response.status).to eq(400)
      end

      it 'returns a helpful JSON error message' do
        parsed_body = JSON.parse(last_response.body)
        expect(parsed_body['errors']).to eq({ 'x' => 'Parameter is required' })
      end
    end

    context 'when the x coordinate is a string' do
      let(:x_coordinate) { "hello x" }

      it 'returns 400 bad request' do
        expect(last_response.status).to eq(400)
      end

      it 'returns a helpful JSON error message' do
        parsed_body = JSON.parse(last_response.body)
        expect(parsed_body['errors']).to eq({ 'x' =>  "'hello x' is not a valid Integer" })
      end
    end
  end

  describe 'given the y coordinate parameter is invalid' do
    context 'when the y coordinate is missing' do
      let(:y_coordinate) { nil }

      it 'returns 400 bad request' do
        expect(last_response.status).to eq(400)
      end

      it 'returns a helpful JSON error message' do
        parsed_body = JSON.parse(last_response.body)
        expect(parsed_body['errors']).to eq({ 'y' => 'Parameter is required' })
      end
    end

    context 'when the y coordinate is a string' do
      let(:y_coordinate) { "hello y" }

      it 'returns 400 bad request' do
        expect(last_response.status).to eq(400)
      end

      it 'returns a helpful JSON error message' do
        parsed_body = JSON.parse(last_response.body)
        expect(parsed_body['errors']).to eq({ 'y' => "'hello y' is not a valid Integer" })
      end
    end
  end

  context 'when making a valid request' do
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