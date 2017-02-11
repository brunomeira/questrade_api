require 'spec_helper'

require 'questrade_api/rest/symbol'

describe QuestradeApi::REST::Symbol do
  include JSONFixtures

  let(:access_token) { 'XXXX' }
  let(:account_id) { '123456' }
  let(:url) { 'http://test.com'}
  let(:authorization) { OpenStruct.new(access_token: access_token, url: url) }

  context '#get' do
    
  end

  context '.search' do
    let(:prefix) { 'BMO' }

    it 'calls endpoint passing prefix' do
      stub_request(:get, "http://test.com/v1/symbols/search?prefix=#{prefix}")
        .to_return(status: 200, body: '{}').times(1)
      response = QuestradeApi::REST::Symbol.search(authorization, prefix: prefix)

      expect(response.symbols.size).to be(0)
    end

    it 'calls endpoint passing offset' do
      stub_request(:get, "http://test.com/v1/symbols/search?offset=2")
        .to_return(status: 200, body: '{}').times(1)
      response = QuestradeApi::REST::Symbol.search(authorization, offset: 2)

      expect(response.symbols.size).to be(0)
    end

    it 'returns an object that contains a list of searched symbols' do
      stub_request(:get, "http://test.com/v1/symbols/search?prefix=#{prefix}")
        .to_return(status: 200, body: json_string('symbols_search.json'))
      response = QuestradeApi::REST::Symbol.search(authorization, prefix: prefix)

      expect(response.symbols.size).to be(2)

      first_symbol = response.symbols.first
      expect(first_symbol.id).to eq(9292)
      expect(first_symbol.data.to_h).to eq(
        symbol: "BMO",
        symbol_id: 9292,
        description: "BANK OF MONTREAL",
        security_type: "Stock",
        listing_exchange: "NYSE",
        is_tradable: true,
        is_quotable: true,
        currency: "USD"
      )

      last_symbol = response.symbols.last
      expect(last_symbol.id).to eq(9300)
      expect(last_symbol.data.to_h).to eq(
        symbol: "BMO.PRJ.TO",
        symbol_id: 9300,
        description: "BANK OF MONTREAL CL B SR 13",
        security_type: "Stock",
        listing_exchange: "TSX",
        is_tradable: true,
        is_quotable: true,
        currency: "CAD"
      )
    end
  end

  context '.all' do
    let(:ids) { [8049, 8050] }
    let(:names) { ['AAPL', 'GOOGL'] }

    it 'calls endpoint passing a list of ids' do
      stub_request(:get, "http://test.com/v1/symbols/?ids=8049,8050")
        .to_return(status: 200, body: '{}').times(1)
      response = QuestradeApi::REST::Symbol.all(authorization, ids: ids)

      expect(response.symbols.size).to be(0)
    end

    it 'calls endpoint passing a list of names' do
      stub_request(:get, "http://test.com/v1/symbols/?names=AAPL,GOOGL")
        .to_return(status: 200, body: '{}')
      response = QuestradeApi::REST::Symbol.all(authorization, names: names)

      expect(response.symbols.size).to be(0)
    end

    it 'returns an object that contains a list of symbols' do
      stub_request(:get, "http://test.com/v1/symbols/")
        .to_return(status: 200, body: json_string('symbols.json'))

      response = QuestradeApi::REST::Symbol.all(authorization)

      expect(response.symbols.size).to be(1)

      first_symbol = response.symbols.first
      expect(first_symbol.id).to eq(8049)
      expect(first_symbol.data.to_h).to eq(
        symbol: 'AAPL',
        symbol_id: 8049,
        prev_day_close_price: 102.5,
        high_price52: 102.9,
        low_price52: 63.89,
        average_vol3_months: 43769680,
        average_vol20_days: 12860370,
        outstanding_shares: 5987867000,
        eps: 6.2,
        pe: 16.54,
        dividend: 0.47,
        yield: 1.84,
        ex_date: "2014-08-07T00:00:00.000000-04:00",
        market_cap: 613756367500,
        trade_unit: 1,
        option_type: nil,
        option_duration_type: nil,
        option_root: "",
        option_contract_deliverables: {
          'underlyings' => [],
          'cashInLieu' => 0
        },
        option_exercise_type: nil,
        listing_exchange: "NASDAQ",
        description: "APPLE INC",
        security_type: "Stock",
        option_expiry_date: nil,
        dividend_date: "2014-08-14T00:00:00.000000-04:00",
        option_strike_price: nil,
        is_tradable: true,
        is_quotable: true,
        has_options: true,
        min_ticks: [
          {
            'pivot' => 0,
            'minTick' => 0.0001
          },
          {
            'pivot' => 1,
            'minTick' => 0.01
          }
        ],
        industry_sector: "BasicMaterials",
        industry_group:  "Steel",
        industry_sub_group: "Steel")
    end
  end

  context '.endpoint' do
    it 'calls endpoint with no param passed' do
      url = "/v1/symbols/"
      expect(QuestradeApi::REST::Symbol.endpoint).to eq(url)
    end

    it 'calls endpoint with param passed' do
      url = "/v1/symbols/search"
      expect(QuestradeApi::REST::Symbol.endpoint('search')).to eq(url)
    end
  end
end
