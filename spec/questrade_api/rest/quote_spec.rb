require 'spec_helper'
require 'questrade_api/rest/quote'

describe QuestradeApi::REST::Quote do
  include JSONFixtures

  let(:access_token) { 'XXXX' }
  let(:url) { 'http://test.com'}
  let(:authorization) { OpenStruct.new(access_token: access_token, url: url) }

  context '#endpoint' do
    subject { QuestradeApi::REST::Quote.new(authorization: authorization, id: 10) }

    it 'returns the right endpoint' do
      url = "/v1/markets/quotes/#{10}"

      expect(subject.endpoint).to eq(url)
    end
  end

  context '#get' do
    subject { QuestradeApi::REST::Quote.new(authorization: authorization, id: 10) }

    it 'fetches quote data' do
      stub_request(:get, 'http://test.com/v1/markets/quotes/10')
         .to_return(status: 200, body: json_string('quote_01.json'))

      expect(subject.data).to be_nil

      subject.get

      expect(subject.data.to_h).to eq(
        symbol: "THI.TO",
        symbol_id: 38738,
        tier: "",
        bid_price: 83.65,
        bid_size: 6500,
        ask_price: 83.67,
        ask_size: 9100,
        last_trade_price_tr_hrs: 83.66,
        last_trade_price: 83.66,
        last_trade_size: 3100,
        last_trade_tick: "Equal",
        last_trade_time: "2014-10-24T20:06:40.131000-04:00",
        volume: 80483500,
        open_price: 83.66,
        high_price: 83.86,
        low_price: 83.66,
        delay: 0,
        is_halted: false
      )
    end
  end

  context '.all' do
    it 'fetches quote for an specific symbol' do
      stub_request(:get, 'http://test.com/v1/markets/quotes?ids=12,11')
         .to_return(status: 200, body: json_string('quotes.json'))

      response = QuestradeApi::REST::Quote.all(authorization, [12, 11])

      expect(response.quotes.size).to be(1)

      first_quote = response.quotes.first
      expect(first_quote.data.to_h).to eq(
        symbol: "THI.TO",
        symbol_id: 38738,
        tier: "",
        bid_price: 83.65,
        bid_size: 6500,
        ask_price: 83.67,
        ask_size: 9100,
        last_trade_price_tr_hrs: 83.66,
        last_trade_price: 83.66,
        last_trade_size: 3100,
        last_trade_tick: "Equal",
        last_trade_time: "2014-10-24T20:06:40.131000-04:00",
        volume: 80483500,
        open_price: 83.66,
        high_price: 83.86,
        low_price: 83.66,
        delay: 0,
        is_halted: false
      )
    end
  end

  context '.endpoint' do
    it 'returns the right endpoint' do
      url = "/v1/markets/quotes"
      expect(QuestradeApi::REST::Quote.endpoint).to eq(url)
    end
  end
end
