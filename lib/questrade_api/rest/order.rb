require 'questrade_api/rest/base'

module QuestradeApi
  module REST
    class Order < QuestradeApi::REST::Base
      attr_accessor :account_id, :id

      def initialize(authorization, params = {})
        super(authorization)

        @id = params[:id]
        @account_id = params[:account_id]

        @raw_body = params[:data]
        build_data(params[:data]) if @raw_body
      end

      def self.all(authorization, account_number, params)

        response = super(access_token: authorization.access_token,
                         endpoint: endpoint(account_number),
                         url: authorization.url,
                         params: params)

        result = OpenStruct.new(orders: [])

        if response.status == 200
          result.orders = parse_orders(authorization, account_number, response.body)
        end

        result
      end

      def endpoint
        self.class.endpoint(account_id) + "/#{id}"
      end

      def self.endpoint(account_id)
        "#{BASE_ENDPOINT}/accounts/#{account_id}/orders"
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

      private_class_method :parse_orders
    end
  end
end
