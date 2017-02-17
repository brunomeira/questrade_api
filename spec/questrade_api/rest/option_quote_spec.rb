require 'spec_helper'
require 'questrade_api/rest/option_quote'

describe QuestradeApi::REST::OptionQuote do
  include JSONFixtures

  let(:access_token) { 'XXXX' }
  let(:url) { 'http://test.com'}
  let(:authorization) { OpenStruct.new(access_token: access_token, url: url) }

  context '.fetch' do
    it 'fetches option chain for an specific symbol' do
      params = {
        filters: [
          {
            optionType: "Call",
            underlyingId: 27426,
            expiryDate: "2017-01-20T00:00:00.000000-05:00",
            minstrikePrice: 70,
            maxstrikePrice: 80
          }
        ],
        optionIds: [ 9907637, 9907638 ]
      }

      headers = { 'Accept' => '*/*',
                  'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                  'Authorization' => 'Bearer XXXX',
                  'Content-Type' => 'application/json',
                  'User-Agent' => "QuestradeApi v#{QuestradeApi::VERSION}" }

      stub_request(:post, 'http://test.com/v1/markets/quotes/options')
        .with(body: params.to_json, headers: headers)
        .to_return(status: 200, body: json_string('option_quotes.json'))

      response = QuestradeApi::REST::OptionQuote.fetch(authorization, params)

      expect(response.optionQuotes.size).to be(1)

      first_option = response.optionQuotes.first
      expect(first_option.data.to_h).to eq(
        {
          underlying: "MSFT",
          underlying_id: 27426,
          symbol: "MSFT20Jan17C70.00",
          symbol_id: 7413503,
          bid_price: 4.90,
          bid_size: 0,
          ask_price: 4.95,
          ask_size: 0,
          last_trade_price_tr_hrs: 4.93,
          last_trade_price: 4.93,
          last_trade_size: 0,
          last_trade_tick: "Equal",
          last_trade_time: "2015-08-17T00:00:00.000000-04:00",
          volume: 0,
          open_price: 0,
          high_price: 4.93,
          low_price: 0,
          volatility: 52.374257,
          delta: 0.06985,
          gamma: 0.01038,
          theta: -0.001406,
          vega: 0.074554,
          rho: 0.04153,
          open_interest: 2292,
          delay: 0,
          is_halted: false,
          vwap: 0
        }
      )
    end
  end

  context '.endpoint' do
    it 'returns the right endpoint' do
      url = "/v1/markets/quotes/options"
      expect(QuestradeApi::REST::OptionQuote.endpoint).to eq(url)
    end
  end
end
