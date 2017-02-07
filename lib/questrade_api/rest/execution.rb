require 'questrade_api/rest/base'

module QuestradeApi
  module REST
    class Execution < QuestradeApi::REST::Base
      attr_accessor :account_id

      def initialize(params)
        @account_id = params[:account_id]

        @raw_body = params[:data]
        build_data(params[:data]) if @raw_body
      end

      def self.all(authorization, account_number, params)

        response = super(access_token: authorization.access_token,
                         endpoint: endpoint(account_number),
                         url: authorization.url,
                         params: params)

        result = OpenStruct.new(executions: [])

        if response.status == 200
          result.executions = parse_executions(account_number, response.body)
        end

        result
      end

      def self.endpoint(account_id)
        "#{BASE_ENDPOINT}/accounts/#{account_id}/executions"
      end

      def self.parse_executions(account_id, body)
        raw = JSON.parse(body)

        executions = []

        raw['executions'].each do |execution|
          executions << new(account_id: account_id, data: execution)
        end

        executions
      end

      private_class_method :parse_executions
    end
  end
end
