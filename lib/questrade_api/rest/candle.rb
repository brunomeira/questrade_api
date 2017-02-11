require 'questrade_api/rest/base'

module QuestradeApi
  module REST
    class Candle < QuestradeApi::REST::Base
      def initialize(params)
        @raw_body = params[:data]
        build_data(params[:data]) if @raw_body
      end

      def self.fetch(authorization, symbol_id, params)
        response = super(access_token: authorization.access_token,
                         endpoint: endpoint(symbol_id),
                         url: authorization.url,
                         params: params)

        if response.status == 200
          result = OpenStruct.new(candles: [])
          result.candles = parse_candles(response.body)
          response = result
        end

        response
      end

      def self.endpoint(symbol_id)
        "#{BASE_ENDPOINT}/markets/candles/#{symbol_id}"
      end

      def self.parse_candles(body)
        raw = JSON.parse(body)

        candles = []

        raw['candles'].each do |candle|
          candles << new(data: candle)
        end

        candles
      end

      private_class_method :parse_candles
    end
  end
end
