require 'questrade_api/rest/base'

module QuestradeApi
  module REST
    class Option < QuestradeApi::REST::Base
      def initialize(params)
        @raw_body = params[:data]
        build_data(params[:data]) if @raw_body
      end

      def self.fetch(authorization, symbol_id)
        response = super(access_token: authorization.access_token,
                         endpoint: endpoint(symbol_id),
                         url: authorization.url)

        if response.status == 200
          result = OpenStruct.new(options: [])
          result.options = parse_options(response.body)
          response = result
        end

        response
      end

      def self.endpoint(symbol_id)
        "#{BASE_ENDPOINT}/symbol/#{symbol_id}/options"
      end

      def self.parse_options(body)
        raw = JSON.parse(body)

        options = []

        raw['options'].each do |option|
          options << new(data: option)
        end

        options
      end

      private_class_method :parse_options
    end
  end
end
