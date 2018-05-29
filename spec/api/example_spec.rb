require 'spec_helper'

describe 'Example sinatra test' do
  it 'should return 200 OK!' do
    get '/'

    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq('OK!')
  end
end