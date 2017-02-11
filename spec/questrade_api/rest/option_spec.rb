require 'spec_helper'
require 'questrade_api/rest/option'

describe QuestradeApi::REST::Option do
  include JSONFixtures

  let(:access_token) { 'XXXX' }
  let(:url) { 'http://test.com'}
  let(:authorization) { OpenStruct.new(access_token: access_token, url: url) }

  context '.fetch' do
    it 'fetches option chain for an specific symbol' do
       stub_request(:get, 'http://test.com/v1/symbol/9291/options')
         .to_return(status: 200, body: json_string('options.json'))

      response = QuestradeApi::REST::Option.fetch(authorization, 9291)

      expect(response.options.size).to be(1)

      first_option = response.options.first
      expect(first_option.data.to_h).to eq(
        expiry_date: '2015-01-17T00:00:00.000000-05:00',
        description: 'BANK OF MONTREAL',
        listing_exchange: 'MX',
        option_exercise_type: 'American',
        chain_per_root: [
          {
            "root" => "BMO",
            "chainPerStrikePrice" => [
              {
                "strikePrice" => 60,
                "callSymbolId" => 6101993,
                "putSymbolId" => 6102009
              },
              {
                "strikePrice" => 62,
                "callSymbolId" => 6101994,
                "putSymbolId" => 6102010
              },
              {
                "strikePrice" => 64,
                "callSymbolId" => 6101995,
                "putSymbolId" => 6102011
              }
            ],
            "multiplier" => 100
          }
        ]
      )
    end
  end

  context '.endpoint' do
    it 'returns the right endpoint' do
      url = "/v1/symbol/#{10}/options"
      expect(QuestradeApi::REST::Option.endpoint(10)).to eq(url)
    end
  end
end
