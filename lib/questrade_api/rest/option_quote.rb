require 'questrade_api/rest/base'

module QuestradeApi
  module REST
    class OptionQuote < QuestradeApi::REST::Base
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
          result = OpenStruct.new(optionQuotes: [])
          result.optionQuotes = parse_option_quotes(response.body)
          response = result
        end

        response
      end

      def self.endpoint
        "#{BASE_ENDPOINT}/markets/quotes/options"
      end

      def self.parse_option_quotes(body)
        raw = JSON.parse(body)

        options = []

        raw['optionQuotes'].each do |option|
          options << new(data: option)
        end

        options
      end

      private_class_method :parse_option_quotes
    end
  end
end
