require 'spec_helper'
require 'questrade_api/rest/candle'

describe QuestradeApi::REST::Candle do
  include JSONFixtures

  let(:access_token) { 'XXXX' }
  let(:url) { 'http://test.com'}
  let(:authorization) { OpenStruct.new(access_token: access_token, url: url) }

  context '.all' do
    it 'fetches candle for an specific symbol' do
      start_time = '2014-10-01T00:00:00-05:00'
      end_time = '2014-10-01T00:00:00-05:00'
      interval='OneDay'
      stub_request(:get, 'http://test.com/v1/markets/candles/1010?startTime=2014-10-01T00:00:00-05:00&endTime=2014-10-01T00:00:00-05:00&interval=OneDay')
         .to_return(status: 200, body: json_string('candles.json'))

      params = {
        startTime: start_time,
        endTime: end_time,
        interval: interval
      }

      response = QuestradeApi::REST::Candle.all(authorization, 1010, params)

      expect(response.candles.size).to be(1)

      first_candle = response.candles.first
      expect(first_candle.data.to_h).to eq(
        start: "2014-01-02T00:00:00.000000-05:00",
        end: "2014-01-03T00:00:00.000000-05:00",
        low: 70.3,
        high: 70.78,
        open: 70.68,
        close: 70.73,
        volume: 983609
      )
    end
  end

  context '.endpoint' do
    it 'returns the right endpoint' do
      url = "/v1/markets/candles/1019"
      expect(QuestradeApi::REST::Candle.endpoint(1019)).to eq(url)
    end
  end
end
