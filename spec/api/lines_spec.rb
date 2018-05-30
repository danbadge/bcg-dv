require 'spec_helper'

describe '~/lines' do
  let(:timestamp) { '10:00:00' }
  let(:x_coordinate) { '2' }
  let(:y_coordinate) { '4' }
  let(:parsed_response_body) { JSON.parse(last_response.body) }

  before do
    get '/lines', :timestamp => timestamp, :x => x_coordinate, :y => y_coordinate
  end

  describe 'given a valid request' do
    it 'returns 200 OK' do
      expect(last_response.status).to eq(200)
    end

    context 'when coordinates are 1,1 and timestamp is 10:00:00' do
      let(:x_coordinate) { '1' }
      let(:y_coordinate) { '1' }

      it 'returns line number 0 called M4' do
        expected = [{'id' => '0', 'name' => 'M4'}]
        expect(parsed_response_body).to eq(expected)
      end
    end

    context 'when coordinates match a valid stop that currently has not trains' do
      let(:x_coordinate) { '1' }
      let(:y_coordinate) { '10' }
      let(:timestamp) { '10:09:00' }

      it 'does not return a line' do
        expect(parsed_response_body).to eq([])
      end
    end

    context 'when coordinates are 191,828' do
      let(:x_coordinate) { '191' }
      let(:y_coordinate) { '828' }

      it 'does not return a line' do
        expect(parsed_response_body).to eq([])
      end
    end

    context 'when timestamp is 24:00:00' do
      let(:timestamp) { '24:00:00' }

      it 'does not return a line' do
        expect(parsed_response_body).to eq([])
      end
    end

    context 'when coordinates are 2,9 and timestamp is 10:08:00' do
      let(:x_coordinate) { '2' }
      let(:y_coordinate) { '9' }
      let(:timestamp) { '10:08:00' }

      it 'returns the correct two lines' do
        expected = [
          {'id' => '1', 'name' => '200'},
          {'id' => '2', 'name' => 'S75'},
        ]
        expect(parsed_response_body).to eq(expected)
      end
    end

    context 'when coordinates are 2,9 and timestamp is 10:07:00' do
      let(:x_coordinate) { '2' }
      let(:y_coordinate) { '9' }
      let(:timestamp) { '10:07:00' }

      it 'returns line number 0 called M4' do
        expected = [{'id' => '0', 'name' => 'M4'}]
        expect(parsed_response_body).to eq(expected)
      end
    end

    context 'when coordinates are 3,11 and timestamp is 10:11:00' do
      let(:x_coordinate) { '3' }
      let(:y_coordinate) { '11' }
      let(:timestamp) { '10:11:00' }

      it 'returns line number 0 called M4' do
        expected = [{'id' => '2', 'name' => 'S75'}]
        expect(parsed_response_body).to eq(expected)
      end
    end
  end

  describe 'given an invalid request' do
    context 'when the timestamp parameter is missing' do
      let(:timestamp) { nil }

      it 'returns 400 bad request' do
        expect(last_response.status).to eq(400)
      end

      it 'returns a helpful JSON error message' do
        expected = {
          'error' => "Parameter 'timestamp' is required"
        }
        expect(parsed_response_body).to eq(expected)
      end
    end

    context 'without the x coordinate parameter' do
      let(:x_coordinate) { nil }

      it 'returns 400 bad request' do
        expect(last_response.status).to eq(400)
      end

      it 'returns a helpful JSON error message' do
        expect(parsed_response_body['error']).to eq("Parameter 'x' is required")
      end
    end

    context 'when the x coordinate parameter is a string' do
      let(:x_coordinate) { 'hello x' }

      it 'returns 400 bad request' do
        expect(last_response.status).to eq(400)
      end

      it 'returns a helpful JSON error message' do
        expect(parsed_response_body['error']).to eq("'hello x' is not a valid Integer for parameter 'x'")
      end
    end

    context 'when the y coordinate parameter is missing' do
      let(:y_coordinate) { nil }

      it 'returns 400 bad request' do
        expect(last_response.status).to eq(400)
      end

      it 'returns a helpful JSON error message' do
        expect(parsed_response_body['error']).to eq("Parameter 'y' is required")
      end
    end

    context 'when the y coordinate parameter is a string' do
      let(:y_coordinate) { 'hello y' }

      it 'returns 400 bad request' do
        expect(last_response.status).to eq(400)
      end

      it 'returns a helpful JSON error message' do
        expect(parsed_response_body['error']).to eq("'hello y' is not a valid Integer for parameter 'y'")
      end
    end
  end
end
