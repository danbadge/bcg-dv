require 'spec_helper'

describe '~/lines/:name' do
  let(:name) { 'M4' }
  let(:parsed_response_body) { JSON.parse(last_response.body) }

  before do
    get "/lines/#{name}"
  end

  context 'when requesting line M4' do
    it 'returns 200 OK' do
      expect(last_response.status).to eq(200)
    end

    it 'returns a delay of 1 minute' do
      expected = {
        'name' => 'M4',
        'delay_in_minutes' => '1',
      }
      expect(parsed_response_body).to eq(expected)
    end
  end

  context 'when requesting line 200' do
    let(:name) { '200' }

    it 'returns a delay of 2 minutes' do
      expected = {
        'name' => '200',
        'delay_in_minutes' => '2',
      }
      expect(parsed_response_body).to eq(expected)
    end
  end

  context 'when requesting line S75' do
    let(:name) { 'S75' }

    it 'returns a delay of 10 minutes' do
      expected = {
        'name' => 'S75',
        'delay_in_minutes' => '10',
      }
      expect(parsed_response_body).to eq(expected)
    end
  end

  context 'when the name is unknown' do
    let(:name) { 'this-is-not-a-line' }

    it 'returns 404 bad request' do
      expect(last_response.status).to eq(404)
    end

    it 'returns a helpful JSON error message' do
      expected = {
        'error' => "The line 'this-is-not-a-line' could not be found",
      }
      expect(parsed_response_body).to eq(expected)
    end
  end
end
