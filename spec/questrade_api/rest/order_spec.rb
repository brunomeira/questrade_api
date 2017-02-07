require 'spec_helper'

require 'questrade_api/rest/order'

describe QuestradeApi::REST::Order do
  include JSONFixtures

  let(:access_token) { 'XXXX' }
  let(:account_id) { '123456' }
  let(:url) { 'http://test.com'}
  let(:authorization) { OpenStruct.new(access_token: access_token, url: url) }

  context '.all' do
    it "returns an object that contains a list of all user's orders" do
      time = DateTime.now.to_s
      params = "startTime=#{time}&endTime=#{time}&stateFilter=All"
      full_url =
        url + QuestradeApi::REST::Order.endpoint(account_id) + "?#{params}"

      stub_request(:get, full_url).to_return(status: 200, body: json_string('orders.json'))

      response = QuestradeApi::REST::Order.all(authorization, account_id,
                                               startTime: time, endTime: time, stateFilter: 'All')

      expect(response.orders.size).to be(1)

      first_order = response.orders.first
      expect(first_order.account_id).to eq(account_id)
      expect(first_order.data.to_h).to eq(
        id: 173577870,
        symbol: 'AAPL',
        symbol_id: 8049,
        total_quantity: 100,
        open_quantity: 100,
        filled_quantity: 0,
        canceled_quantity: 0,
        side: "Buy",
        type: "Limit",
        limit_price: 500.95,
        stop_price: nil,
        is_all_or_none: false,
        is_anonymous: false,
        iceberg_qty: nil,
        min_quantity: nil,
        avg_exec_price: nil,
        last_exec_price: nil,
        source: "TradingAPI",
        time_in_force: "Day",
        gtd_date: nil,
        state: "Canceled",
        client_reason_str: "",
        chain_id: 173577870,
        creation_time: "2014-10-23T20:03:41.636000-04:00",
        update_time: "2014-10-23T20:03:42.890000-04:00",
        notes: "",
        primary_route: "AUTO",
        secondary_route: "",
        order_route: "LAMP",
        venue_holding_order: "",
        comission_charged: 0,
        exchange_order_id: "XS173577870",
        is_significant_share_holder: false,
        is_insider: false,
        is_limit_offset_in_dollar: false,
        user_id:  3000124,
        placement_commission: nil,
        legs: [],
        strategy_type: "SingleLeg",
        trigger_stop_price: nil,
        order_group_id: 0,
        order_class: nil,
        main_chain_id: 0
      )
    end
  end

  context '#endpoint' do
    let(:id) { '1' }
    subject {
      QuestradeApi::REST::Order.new(authorization, id: '1', account_id: account_id)
    }

    it 'calls right endpoint' do
      url = "/v1/accounts/#{account_id}/orders/#{id}"
      expect(subject.endpoint).to eq(url)
    end
  end

  context '.endpoint' do
    it 'calls right endpoint' do
      url = "/v1/accounts/#{account_id}/orders"
      expect(QuestradeApi::REST::Order.endpoint(account_id)).to eq(url)
    end
  end
end
