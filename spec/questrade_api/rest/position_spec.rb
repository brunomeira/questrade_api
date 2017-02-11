require 'spec_helper'

require 'questrade_api/rest/position'

describe QuestradeApi::REST::Position do
  include JSONFixtures

  let(:access_token) { 'XXXX' }
  let(:account_id) { '123456' }
  let(:url) { 'http://test.com'}
  let(:authorization) { OpenStruct.new(access_token: access_token, url: url) }

  context '.fetch' do
    it "returns an object that contains a list of all user's positions" do
      full_url = url + QuestradeApi::REST::Position.endpoint(account_id)

      stub_request(:get, full_url).to_return(status: 200, body: json_string('positions.json'))

      response = QuestradeApi::REST::Position.fetch(authorization, account_id)

      expect(response.positions.size).to be(1)

      first_position = response.positions.first
      expect(first_position.account_id).to eq(account_id)
      expect(first_position.data.to_h).to eq(
        symbol: "THI.TO",
        symbol_id: 38738 ,
        open_quantity: 100,
        current_market_value: 6017,
        current_price: 60.17,
        average_entry_price: 60.23,
        closed_pnl: 0,
        open_pnl: -6,
        total_cost: false,
        is_real_time: "Individual",
        is_under_reorg: false
      )
    end
  end

  context '.endpoint' do
    it 'calls right endpoint' do
      url = "/v1/accounts/#{account_id}/positions"
      expect(QuestradeApi::REST::Position.endpoint(account_id)).to eq(url)
    end
  end
end
