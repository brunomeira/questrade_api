require 'questrade_api/rest/base'

module QuestradeApi
  module REST
    class Market < QuestradeApi::REST::Base
      def initialize(params)
        @raw_body = params[:data]
        build_data(params[:data]) if @raw_body
      end

      def self.fetch(authorization)
        response = super(access_token: authorization.access_token,
                         endpoint: endpoint,
                         url: authorization.url)

        result = OpenStruct.new(markets: [])

        result.markets = parse_markets(response.body) if response.status == 200

        result
      end

      def self.endpoint
        "#{BASE_ENDPOINT}/markets"
      end

      def self.parse_markets(body)
        raw = JSON.parse(body)

        markets = []

        raw['markets'].each do |market|
          markets << new(data: market)
        end

        markets
      end

      private_class_method :parse_markets
    end
  end
end
