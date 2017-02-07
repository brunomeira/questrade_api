require 'spec_helper'

require 'questrade_api/rest/account'

describe QuestradeApi::REST::Account do
  include JSONFixtures

  let(:access_token) { 'XXXX' }
  let(:url) { 'http://test.com'}
  let(:authorization) { OpenStruct.new(access_token: access_token, url: url) }

  context 'instance methods' do
    let(:id) { '123' }
    subject { QuestradeApi::REST::Account.new(authorization, id: id) }

    it 'returns a list of activities' do
      expect(QuestradeApi::REST::Activity)
        .to(receive(:all).with(authorization, id, {}))
        .once

      subject.activities({})
    end

    it 'returns a list of executions' do
      expect(QuestradeApi::REST::Execution)
        .to(receive(:all).with(authorization, id, {}))
        .once

      subject.executions({})
    end

    it 'returns a list of positions' do
      expect(QuestradeApi::REST::Position)
        .to(receive(:all).with(authorization, id))
        .once

      subject.positions
    end

    it 'returns a list of balances' do
      expect(QuestradeApi::REST::Balance)
        .to(receive(:all).with(authorization, id))
        .once

      subject.balances
    end
  end

  context '.all' do
    it "returns an object that contains a list of all user's accounts" do
      full_url = url + QuestradeApi::REST::Account.endpoint
      stub_request(:get, full_url).to_return(status: 200,
                                             body: json_string('accounts.json'),
                                             headers: {})

      response = QuestradeApi::REST::Account.all(authorization)

      expect(response.accounts.size).to be(2)

      first_account = response.accounts.first
      expect(first_account.id).to eq('26598145')
      expect(first_account.user_id).to eq('123456')
      expect(first_account.data.to_h).to eq(type:'Margin',
                                            number: '26598145',
                                            status: 'Active',
                                            is_primary: true,
                                            is_billing: true,
                                            client_account_type: 'Individual')

      second_account = response.accounts.last
      expect(second_account.id).to eq('11122233')
      expect(second_account.user_id).to eq('123456')
      expect(second_account.data.to_h).to eq(type:'Margin',
                                            number: '11122233',
                                            status: 'Active',
                                            is_primary: false,
                                            is_billing: true,
                                            client_account_type: 'Individual')
    end
  end

  context '.endpoint' do
    it 'calls right endpoint' do
      url = '/v1/accounts'
      expect(QuestradeApi::REST::Account.endpoint).to eq(url)
    end
  end
end
