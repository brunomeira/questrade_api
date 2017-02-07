require 'spec_helper'

require 'questrade_api/rest/balance'

describe QuestradeApi::REST::Balance do
  include JSONFixtures

  let(:access_token) { 'XXXX' }
  let(:account_id) { '123456' }
  let(:url) { 'http://test.com'}
  let(:authorization) { OpenStruct.new(access_token: access_token, url: url) }

  context '.all' do
    it "returns an object that contains a list of all user's balances" do
      full_url =
        url + QuestradeApi::REST::Balance.endpoint(account_id)
      stub_request(:get, full_url).to_return(status: 200, body: json_string('balances.json'))

      response = QuestradeApi::REST::Balance.all(authorization, account_id)

      expect(response.per_currency_balances.size).to be(2)
      expect(response.combined_balances.size).to be(1)
      expect(response.sod_per_currency_balances.size).to be(1)
      expect(response.sod_combined_balances.size).to be(1)
    end
  end

  context '.endpoint' do
    it 'calls right endpoint' do
      url = "/v1/accounts/#{account_id}/balances"
      expect(QuestradeApi::REST::Balance.endpoint(account_id)).to eq(url)
    end
  end
end
