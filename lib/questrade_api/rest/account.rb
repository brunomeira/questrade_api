require 'questrade_api/modules/util'

require 'questrade_api/rest/base'
require 'questrade_api/rest/activity'
require 'questrade_api/rest/position'
require 'questrade_api/rest/balance'
require 'questrade_api/rest/execution'

module QuestradeApi
  module REST
    # @author Bruno Meira <goesmeira@gmail.com>
    class Account < QuestradeApi::REST::Base
      attr_accessor :user_id

      def initialize(authorization, params)
        super(authorization)

        @id = params[:id]
        @user_id = params[:user_id]

        @raw_body = params[:data]
        build_data(params[:data]) if @raw_body
      end

      #
      # Fetch activities associated with account.
      #
      # @param see QuestradeApi::REST::Activity.fetch
      #
      # @return [OpenStruct(executions: [QuestradeApi::REST::Activity)]
      def activities(params)
        QuestradeApi::REST::Activity.fetch(authorization, id, params)
      end

      # Fetch executions associated with account.
      #
      # @param see QuestradeApi::REST::Execution.fetch
      #
      # @return [OpenStruct(executions: [QuestradeApi::REST::Execution)]
      def executions(params)
        QuestradeApi::REST::Execution.fetch(authorization, id, params)
      end

      # Fetch balances associated with account.
      #
      # @return [OpenStruct(per_currency_balances)]
      def balances
        QuestradeApi::REST::Balance.fetch(authorization, id)
      end

      # Fetch positions associated with account.
      #
      # @return [OpenStruct(positions: [QuestradeApi::REST::Position])]
      def positions
        QuestradeApi::REST::Position.fetch(authorization, id)
      end

      # Fetch accounts for specific authorized user.
      #
      # @param authorization is any object that
      #   responds to #access_token and #url
      #
      # @return [OpenStruct(accounts: [QuestradeApi::REST::Account])] if call to server is successful
      # @return [Faraday::Response] if call to server is not successful
      def self.fetch(authorization)
        response = super(access_token: authorization.access_token,
                         endpoint: endpoint,
                         url: authorization.url)

        result = OpenStruct.new(accounts: [])

        if response.status == 200
          result.accounts = parse_accounts(authorization, response.body)
          response = result
        end

        response
      end

      def self.endpoint
        "#{BASE_ENDPOINT}/accounts"
      end

      def self.parse_accounts(authorization, body)
        raw = JSON.parse(body)
        clients = []

        raw['accounts'].each do |client|
          clients << new(authorization,
                         id: client['number'],
                         user_id: raw['userId'],
                         data: client)
        end

        clients
      end

      private_class_method :parse_accounts
    end
  end
end
