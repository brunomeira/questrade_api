require 'questrade_api/rest/base'

module QuestradeApi
  module REST
    class Quote < QuestradeApi::REST::Base
      attr_accessor :id

      def initialize(params)
        super(params[:authorization])
        @id = params[:id]

        @raw_body = params[:data]
        build_data(params[:data]) if @raw_body
      end

      def fetch
        response = super(endpoint: endpoint)

        if response.status == 200
          parse_quotes(response.body)
        end

        response
      end

      def self.fetch(authorization, ids)
        response = super(access_token: authorization.access_token,
                         endpoint: endpoint,
                         url: authorization.url,
                         params: { ids: ids.join(',') })

        if response.status == 200
          result = OpenStruct.new(quotes: [])
          result.quotes = parse_quotes(authorization, response.body)
          response = result
        end

        response
      end

      def endpoint
        self.class.endpoint + "/#{id}"
      end

      def self.endpoint
        "#{BASE_ENDPOINT}/markets/quotes"
      end

      def self.parse_quotes(authorization, body)
        raw = JSON.parse(body)

        quotes = []

        raw['quotes'].each do |quote|
          quotes << new(authorization: authorization,
                        id: quote['symbolId'], data: quote)
        end

        quotes
      end

      private_class_method :parse_quotes

      private

      def parse_quotes(body)
        raw = JSON.parse(body)

        raw['quotes'].each do |quote|
          build_data(quote)
        end
      end
    end
  end
end
