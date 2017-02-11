require 'spec_helper'

require 'questrade_api/rest/activity'

describe QuestradeApi::REST::Activity do
  include JSONFixtures

  let(:access_token) { 'XXXX' }
  let(:account_id) { '123456' }
  let(:url) { 'http://test.com'}
  let(:authorization) { OpenStruct.new(access_token: access_token, url: url) }

  context '.fetch' do
    it "returns an object that contains a list of all user's activities for the specific period" do
      start_time = '2011-02-16T00:00:00.000000-05:00'
      end_time = '2011-02-16T00:00:00.000000-05:00'
      params = "startTime=#{start_time}&endTime=#{end_time}"
      full_url =
        url + QuestradeApi::REST::Activity.endpoint(account_id) + "?#{params}"
      stub_request(:get, full_url).to_return(status: 200, body: json_string('activities.json'))

      response = QuestradeApi::REST::Activity.fetch(authorization, account_id,
                                                  { startTime: start_time,
                                                    endTime: end_time })

      expect(response.activities.size).to be(2)

      first_activity = response.activities.first
      expect(first_activity.account_id).to eq(account_id)
      expect(first_activity.data.to_h).to eq(trade_date: '2011-02-16T00:00:00.000000-05:00',
                                             transaction_date: '2011-02-16T00:00:00.000000-05:00',
                                             settlement_date: '2011-02-16T00:00:00.000000-05:00',
                                             action: '',
                                             symbol: '',
                                             symbol_id: 0,
                                             description: 'INT FR 02/04 THRU02/15@ 4 3/4%BAL  205,006   AVBAL  204,966 ',
                                             currency: 'USD',
                                             quantity: 0,
                                             price: 0,
                                             gross_amount: 0,
                                             commission: 0,
                                             net_amount: -320.08,
                                             type: 'Interest')

      second_activity = response.activities.last
      expect(second_activity.account_id).to eq(account_id)
      expect(second_activity.data.to_h).to eq(trade_date: '2011-01-16T00:00:00.000000-05:00',
                                              transaction_date: '2011-01-16T00:00:00.000000-05:00',
                                              settlement_date: '2011-01-16T00:00:00.000000-05:00',
                                              action: '',
                                              symbol: '',
                                              symbol_id: 0,
                                              description: 'INT FR 02/04 THRU02/15@ 4 3/4%BAL  205,006   AVBAL  204,966 ',
                                              currency: 'USD',
                                              quantity: 0,
                                              price: 0,
                                              gross_amount: 0,
                                              commission: 0,
                                              net_amount: 120.08,
                                              type: 'Interest')
    end
  end

  context '.endpoint' do
    it 'calls right endpoint' do
      url = "/v1/accounts/#{account_id}/activities"
      expect(QuestradeApi::REST::Activity.endpoint(account_id)).to eq(url)
    end
  end
end
