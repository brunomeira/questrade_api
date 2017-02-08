require 'spec_helper'

require 'questrade_api/rest/execution'

describe QuestradeApi::REST::Execution do
  include JSONFixtures

  let(:access_token) { 'XXXX' }
  let(:account_id) { '123456' }
  let(:url) { 'http://test.com'}
  let(:authorization) { OpenStruct.new(access_token: access_token, url: url) }

  context '.all' do
    it "returns an object that contains a list of all user's executions for the specific period" do
      start_time = '2014-03-31T13:38:29-04:00'
      end_time = '2014-03-31T13:38:29-04:00'
      params = "startTime=#{start_time}&endTime=#{end_time}"
      full_url =
        url + QuestradeApi::REST::Execution.endpoint(account_id) + "?#{params}"
      stub_request(:get, full_url).to_return(status: 200, body: json_string('executions.json'))

      response = QuestradeApi::REST::Execution.all(authorization, account_id,
                                                   startTime: start_time,
                                                   endTime: end_time)

      expect(response.executions.size).to be(2)

      first_execution = response.executions.first
      expect(first_execution.account_id).to eq(account_id)
      expect(first_execution.data.to_h).to eq(symbol: 'AAPL',
                                              symbol_id: 8049,
                                              quantity: 10,
                                              side: 'Buy',
                                              price: 536.87,
                                              id: 53817310,
                                              order_id: 177106005,
                                              order_chain_id: 177106005,
                                              exchange_exec_id: 'XS1771060050147',
                                              timestamp: '2014-03-31T13:38:29.000000-04:00',
                                              notes: '',
                                              venue: 'LAMP',
                                              total_cost: 5368.7,
                                              order_placement_commission: 0,
                                              commission: 4.95,
                                              execution_fee: 0,
                                              sec_fee: 0,
                                              canadian_execution_fee: 0,
                                              parent_id: 0)

      second_execution = response.executions.last
      expect(second_execution.account_id).to eq(account_id)
      expect(second_execution.data.to_h).to eq(symbol: 'GOOGL',
                                               symbol_id: 8048,
                                               quantity: 11,
                                               side: 'Buy',
                                               price: 531.87,
                                               id: 53817311,
                                               order_id: 177106015,
                                               order_chain_id: 177106015,
                                               exchange_exec_id: 'XS1773060050147',
                                               timestamp: '2014-03-31T13:38:29.000000-04:00',
                                               notes: '',
                                               venue: 'LAMP',
                                               total_cost: 5268.7,
                                               order_placement_commission: 0,
                                               commission: 2.95,
                                               execution_fee: 0,
                                               sec_fee: 0,
                                               canadian_execution_fee: 0,
                                               parent_id: 0)
    end
  end

  context '.endpoint' do
    it 'calls right endpoint' do
      url = "/v1/accounts/#{account_id}/executions"
      expect(QuestradeApi::REST::Execution.endpoint(account_id)).to eq(url)
    end
  end
end
