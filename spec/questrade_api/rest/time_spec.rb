require 'spec_helper'

require 'questrade_api/rest/time'

describe QuestradeApi::REST::Time do
  include JSONFixtures

  let(:access_token) { 'XXXX' }
  let(:url) { 'http://test.com'}
  let(:authorization) { OpenStruct.new(access_token: access_token, url: url) }

  subject { QuestradeApi::REST::Time.new(authorization) }

  context '#fetch' do
    let(:url) { 'http://test.com/v1/time' }

    it 'calls the proper endpoint with proper data' do
      expect(subject.data).to be_nil

      stub_request(:get, url).to_return(status: 200,
                                        body: json_string('time.json'))
      subject.fetch

      expect(subject.data).to_not be_nil
      expect(subject.data.time).to eq('2017-01-24T12:14:42.730000-04:00')
    end
  end

  context '.endpoint' do
    it 'returns right endpoint' do
      expect(QuestradeApi::REST::Time.endpoint).to eq('/v1/time')
    end
  end
end
