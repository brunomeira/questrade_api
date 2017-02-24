require 'questrade_api/rest/base'

module QuestradeApi
  module REST
    class Order < QuestradeApi::REST::Base
      def initialize(authorization, params = {})
        super(authorization)

        @id = params[:id]
        @account_id = params[:account_id]

        @raw_body = params[:data]
        build_data(params[:data]) if @raw_body
      end

      def update(params = {})
        params[:accountNumber] = account_id

        response = self.class.post(access_token: authorization.access_token,
                                   endpoint: endpoint,
                                   url: authorization.url,
                                   body: params.to_json)

        parse_order(response.body) if response.status == 200

        response
      end

      def self.create(authorization, account_number, params = {})
        params[:accountNumber] = account_number

        response = post(access_token: authorization.access_token,
                        endpoint: endpoint(account_number),
                        url: authorization.url,
                        body: params.to_json)

        build_orders(authorization, account_number, response)
      end

      def self.fetch(authorization, account_number, params)
        response = super(access_token: authorization.access_token,
                         endpoint: endpoint(account_number),
                         url: authorization.url,
                         params: params)

        build_orders(authorization, account_number, response)
      end

      def endpoint
        self.class.endpoint(account_id) + "/#{id}"
      end

      def self.endpoint(account_id)
        "#{BASE_ENDPOINT}/accounts/#{account_id}/orders"
      end

      private

      def parse_order(body)
        raw = JSON.parse(body)
        build_data(raw['orders'].first) if raw['orders'].size > 0
      end

      def self.parse_orders(authorization, account_id, body)
        raw = JSON.parse(body)

        orders = []

        raw['orders'].each do |order|
          orders << new(authorization,
                        account_id: account_id, id: order['id'], data: order)
        end

        orders
      end

      def self.build_orders(authorization, account_number, response)
        result = response

        if response.status == 200
          result = OpenStruct.new(orders: [])
          result.orders = parse_orders(authorization, account_number, response.body)
        end

        result
      end

      private_class_method :parse_orders, :build_orders
    end
  end
end
