require 'questrade_api/rest/base'

module QuestradeApi
  module REST
    class StrategyQuote < QuestradeApi::REST::Base
      def initialize(params)
        @raw_body = params[:data]
        build_data(params[:data]) if @raw_body
      end

      def self.fetch(authorization, params)
        response = post(access_token: authorization.access_token,
                        endpoint: endpoint,
                        url: authorization.url,
                        body: params.to_json)

        if response.status == 200
          result = OpenStruct.new(strategyQuotes: [])
          result.strategyQuotes = parse_strategy_quotes(response.body)
          response = result
        end

        response
      end

      def self.endpoint
        "#{BASE_ENDPOINT}/markets/quotes/strategies"
      end

      def self.parse_strategy_quotes(body)
        raw = JSON.parse(body)

        strategies = []

        raw['strategyQuotes'].each do |strategy|
          strategies << new(data: strategy)
        end

        strategies
      end

      private_class_method :parse_strategy_quotes
    end
  end
end
