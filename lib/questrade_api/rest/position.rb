require 'questrade_api/rest/base'

module QuestradeApi
  module REST
    class Position < QuestradeApi::REST::Base
      def initialize(params)
        @account_id = params[:account_id]

        @raw_body = params[:data]
        build_data(params[:data]) if @raw_body
      end

      def self.fetch(authorization, account_number)
        response = super(access_token: authorization.access_token,
                         endpoint: endpoint(account_number),
                         url: authorization.url)

        result = OpenStruct.new(positions: [])

        if response.status == 200
          result.positions = parse_positions(account_number, response.body)
        end

        result
      end

      def self.endpoint(account_id)
        "#{BASE_ENDPOINT}/accounts/#{account_id}/positions"
      end

      def self.parse_positions(account_id, body)
        raw = JSON.parse(body)

        positions = []

        raw['positions'].each do |position|
          positions << new(account_id: account_id, data: position)
        end

        positions
      end

      private_class_method :parse_positions
    end
  end
end
