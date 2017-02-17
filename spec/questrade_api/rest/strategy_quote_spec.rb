require 'spec_helper'
require 'questrade_api/rest/strategy_quote'

describe QuestradeApi::REST::StrategyQuote do
  include JSONFixtures

  let(:access_token) { 'XXXX' }
  let(:url) { 'http://test.com'}
  let(:authorization) { OpenStruct.new(access_token: access_token, url: url) }

  context '.fetch' do
    it 'fetches strategy chain for an specific symbol' do
      params = {
        variants: [
          {
            variantId: 1,
            strategy: "Custom",
            legs: [
              {
                symbolId: 27426,
                ratio: 1000,
                action: "Buy"
              },
              {
                symbolId: 10550014,
                ratio: 10,
                action: "Sell"
              }
            ]
          }
        ]
      }

      headers = { 'Accept' => '*/*',
                  'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                  'Authorization' => 'Bearer XXXX',
                  'Content-Type' => 'application/json',
                  'User-Agent' => "QuestradeApi v#{QuestradeApi::VERSION}" }

      stub_request(:post, 'http://test.com/v1/markets/quotes/strategies')
        .with(body: params.to_json, headers: headers)
        .to_return(status: 200, body: json_string('strategy_quotes.json'))

      response = QuestradeApi::REST::StrategyQuote.fetch(authorization, params)

      expect(response.strategyQuotes.size).to be(1)

      first_strategy = response.strategyQuotes.first
      expect(first_strategy.data.to_h).to eq(
        {
          variant_id: 1,
          bid_price: 27.2,
          ask_price: 27.23,
          underlying: "MSFT",
          underlying_id: 27426,
          open_price: nil,
          volatility: 0,
          delta: 1,
          gamma: 0,
          theta: 0,
          vega: 0,
          rho: 0,
          is_real_time: true
        }
      )
    end
  end

  context '.endpoint' do
    it 'returns the right endpoint' do
      url = "/v1/markets/quotes/strategies"
      expect(QuestradeApi::REST::StrategyQuote.endpoint).to eq(url)
    end
  end
end
