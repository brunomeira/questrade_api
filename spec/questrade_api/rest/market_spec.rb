require 'spec_helper'

require 'questrade_api/rest/market'

describe QuestradeApi::REST::Market do
  include JSONFixtures

  let(:access_token) { 'XXXX' }
  let(:account_id) { '123456' }
  let(:url) { 'http://test.com'}
  let(:authorization) { OpenStruct.new(access_token: access_token, url: url) }

  context '.all' do
    it "returns an object that contains a list of all supported" do
      full_url = url + QuestradeApi::REST::Market.endpoint

      stub_request(:get, full_url).to_return(status: 200, body: json_string('markets.json'))

      response = QuestradeApi::REST::Market.all(authorization)

      expect(response.markets.size).to be(1)

      first_market = response.markets.first
      expect(first_market.data.to_h).to eq(
        name: "TSX",
        trading_venues: [
          "TSX",
          "ALPH",
          "CHIC",
          "OMGA",
          "PURE"
        ],
        default_trading_venue: "AUTO",
        primary_order_routes: [
          "AUTO"
        ],
        secondary_order_routes: [
          "TSX",
          "AUTO"
        ],
        level1_feeds: [
          "ALPH",
          "CHIC",
          "OMGA",
          "PURE",
          "TSX"
        ],
        extended_start_time: "2014-10-06T07:00:00.000000-04:00",
        start_time: "2014-10-06T09:30:00.000000-04:00",
        end_time: "2014-10-06T16:00:00.000000-04:00",
        currency: "CAD",
        snap_quotes_limit: 99999
      )
    end
  end

  context '.endpoint' do
    it 'calls right endpoint' do
      url = "/v1/markets"
      expect(QuestradeApi::REST::Market.endpoint).to eq(url)
    end
  end
end
