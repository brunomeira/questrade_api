require 'questrade_api/rest/base'

module QuestradeApi
  module REST
    class Balance < QuestradeApi::REST::Base
      attr_accessor :account_id

      def initialize(params)
        @account_id = params[:account_id]

        @raw_body = params[:data]
        build_data(params[:data]) if @raw_body
      end

      def self.all(authorization, account_number)
        response = super(access_token: authorization.access_token,
                         endpoint: endpoint(account_number),
                         url: authorization.url)

        result = OpenStruct.new(per_currency_balances: [],
                                combined_balances: [],
                                sod_per_currency_balances: [],
                                sod_combined_balances: [])

        if response.status == 200
          parse_balances(account_number, response.body).each do |key, value|
            result.send("#{key}=", value)
          end
        end

        result
      end

      def self.endpoint(account_id)
        "#{BASE_ENDPOINT}/accounts/#{account_id}/balances"
      end

      def self.parse_balances(account_number, body)
        raw = JSON.parse(body)
        balances = {
          per_currency_balances: [],
          combined_balances: [],
          sod_per_currency_balances: [],
          sod_combined_balances: []
        }

        raw['perCurrencyBalances'].each do |balance|
          balances[:per_currency_balances] << new(account_id: account_number,
                                                  data: balance)
        end

        raw['combinedBalances'].each do |balance|
          balances[:combined_balances] << new(account_id: account_number,
                                              data: balance)
        end

        raw['sodPerCurrencyBalances'].each do |balance|
          balances[:sod_per_currency_balances] << new(account_id: account_number,
                                                      data: balance)
        end

        raw['sodCombinedBalances'].each do |balance|
          balances[:sod_combined_balances] << new(account_id: account_number,
                                                  data: balance)
        end

        balances
      end

      private_class_method :parse_balances
    end
  end
end
