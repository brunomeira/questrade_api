require 'spec_helper'

require 'questrade_api/rest/order'

describe QuestradeApi::REST::Order do
  include JSONFixtures

  let(:access_token) { 'XXXX' }
  let(:account_id) { '123456' }
  let(:url) { 'http://test.com'}
  let(:authorization) { OpenStruct.new(access_token: access_token, url: url) }
  let(:params) {
    {
      accountNumber: account_id,
      symbolId: 8049,
      quantity: 10,
      icebergQuantity: 1,
      limitPrice: 537,
      isAllOrNone: true,
      isAnonymous: false,
      orderType: "Limit",
      timeInForce: "GoodTillCanceled",
      action: "Buy",
      primaryRoute: "AUTO",
      secondaryRoute: "AUTO"
    }
  }

  let(:headers) {
    { 'Accept' => '*/*',
      'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Authorization' => 'Bearer XXXX',
      'Content-Type' => 'application/json',
      'User-Agent' => "QuestradeApi v#{QuestradeApi::VERSION}" }
  }

  context '#update' do
    let(:id) { 177106005 }
    subject { QuestradeApi::REST::Order.new(authorization,
                                            id: id, account_id: account_id ) }

    it 'updates an existing order' do
      url = "http://test.com/v1/accounts/#{account_id}/orders/#{id}"
      stub_request(:post, url)
        .with(body: params.to_json, headers: headers)
        .to_return(status: 200, body: json_string('create_update_order.json'))

      subject.update(params)

      expect(subject.data.to_h).to eq(
        id: 177106005,
        symbol: "AAPL",
        symbol_id: 8049,
        total_quantity: 10,
        open_quantity: 10,
        filled_quantity: 0,
        canceled_quantity: 0,
        side: "Buy",
        order_type: "Limit",
        limit_price: 537,
        stop_price: nil,
        is_all_or_none: true,
        is_anonymous: false,
        iceberg_qty: 1,
        min_quantity: nil,
        avg_exec_price: nil,
        last_exec_price: nil,
        source: "TradingAPI",
        time_in_force: "GoodTillCanceled",
        gtd_date: nil,
        state: "Pending",
        client_reason_str: "",
        chain_id: 177106005,
        creation_time: "2014-10-24T17:48:20.546000-04:00",
        update_time: "2014-10-24T17:48:20.876000-04:00",
        notes: "",
        primary_route: "LAMP",
        secondary_route: "AUTO",
        order_route: "LAMP",
        venue_holding_order: "",
        comission_charged: 0,
        exchange_order_id: "",
        is_significant_share_holder: false,
        is_insider: false,
        is_limit_offset_in_dollar: false,
        user_id: 3000124,
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

  context '.create' do
    it "places an order" do
      url = "http://test.com/v1/accounts/#{account_id}/orders"
      stub_request(:post, url)
        .with(body: params.to_json, headers: headers)
        .to_return(status: 200, body: json_string('create_update_order.json'))

      response = QuestradeApi::REST::Order.create(authorization, account_id, params)

      expect(response.orders.size).to be(1)

      first_order = response.orders.first
      expect(first_order.account_id).to eq(account_id)
      expect(first_order.data.to_h).to eq(
        id: 177106005,
        symbol: "AAPL",
        symbol_id: 8049,
        total_quantity: 10,
        open_quantity: 10,
        filled_quantity: 0,
        canceled_quantity: 0,
        side: "Buy",
        order_type: "Limit",
        limit_price: 537,
        stop_price: nil,
        is_all_or_none: true,
        is_anonymous: false,
        iceberg_qty: 1,
        min_quantity: nil,
        avg_exec_price: nil,
        last_exec_price: nil,
        source: "TradingAPI",
        time_in_force: "GoodTillCanceled",
        gtd_date: nil,
        state: "Pending",
        client_reason_str: "",
        chain_id: 177106005,
        creation_time: "2014-10-24T17:48:20.546000-04:00",
        update_time: "2014-10-24T17:48:20.876000-04:00",
        notes: "",
        primary_route: "LAMP",
        secondary_route: "AUTO",
        order_route: "LAMP",
        venue_holding_order: "",
        comission_charged: 0,
        exchange_order_id: "",
        is_significant_share_holder: false,
        is_insider: false,
        is_limit_offset_in_dollar: false,
        user_id: 3000124,
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

  context '.fetch' do
    it "returns an object that contains a list of all user's orders" do
      time = '2014-03-31T13:38:29-04:00'
      params = "startTime=#{time}&endTime=#{time}&stateFilter=All"
      full_url =
        url + QuestradeApi::REST::Order.endpoint(account_id) + "?#{params}"

      stub_request(:get, full_url).to_return(status: 200, body: json_string('orders.json'))

      response = QuestradeApi::REST::Order.fetch(authorization, account_id,
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
