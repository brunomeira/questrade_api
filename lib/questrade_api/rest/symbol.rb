require 'questrade_api/rest/base'

module QuestradeApi
  module REST
    class Symbol < QuestradeApi::REST::Base
      attr_accessor :id

      def initialize(authorization, params = {})
        super(authorization)

        @id = params[:id]

        @raw_body = params[:data]
        build_data(params[:data]) if @raw_body
      end

      def fetch
        response = super(endpoint: endpoint)

        if response.status == 200
          parse_symbols(response.body)
        end

        response
      end

      def endpoint
        self.class.endpoint + "#{id}"
      end

      def self.endpoint(extra = '')
        "#{BASE_ENDPOINT}/symbols/#{extra}"
      end

      def self.search(authorization, params = {})
        response = superclass.fetch(access_token: authorization.access_token,
                                    endpoint: endpoint('search'),
                                    url: authorization.url,
                                    params: params)

        if response.status == 200
          result = OpenStruct.new(symbols: [])
          result.symbols = parse_symbols(authorization, response.body)
          response = result
        end

        response
      end

      def self.fetch(authorization, params = {})
        params[:ids] = params[:ids].join(',') if params[:ids]
        params[:names] = params[:names].join(',') if params[:names]

        response = super(access_token: authorization.access_token,
                         endpoint: endpoint,
                         url: authorization.url,
                         params: params)

        if response.status == 200
          result = OpenStruct.new(symbols: [])
          result.symbols = parse_symbols(authorization, response.body)
          response = result
        end

        response
      end

      # TODO: Review this later
      def self.parse_symbols(authorization, body)
        raw = JSON.parse(body)

        symbols = []

        if raw['symbols']
          raw['symbols'].each do |symbol|
            symbols << new(authorization, id: symbol['symbolId'], data: symbol)
          end
        end

        if raw['symbol']
          raw['symbol'].each do |symbol|
            symbols << new(authorization, id: symbol['symbolId'], data: symbol)
          end
        end

        symbols
      end

      private_class_method :parse_symbols

      private

      def parse_symbols(body)
        raw = JSON.parse(body)

        raw['symbols'].each do |symbol|
          build_data(symbol)
        end
      end
    end
  end
end
