require 'questrade_api/rest/time'
require 'questrade_api/rest/account'
require 'questrade_api/rest/balance'
require 'questrade_api/rest/position'
require 'questrade_api/rest/execution'
require 'questrade_api/rest/activity'
require 'questrade_api/rest/order'

module QuestradeApi
  module AccountCall
    # Fetch current server time.
    #
    # @return [DateTime] if no issues to call /time endpoint occurs.
    # @return [Faraday::Response] if current server time cannot be fetched.
    def time
      time = QuestradeApi::REST::Time.new(authorization)
      time.fetch
    end

    # Fetch all accounts associated with user.
    #
    # @return [Array<QuestradeApi::REST::Account>]
    def accounts
      QuestradeApi::REST::Account.fetch(authorization)
    end

    # Fetch all positions associated with account.
    #
    # @param account_id [String] to which positions will be fetched.
    #
    # @return [OpenStruct(accounts: Array<QuestradeApi::REST::Position>)]
    def positions(account_id)
      QuestradeApi::REST::Position.fetch(authorization, account_id)
    end

    # Fetch all balances associated with account.
    #
    # @param account_id [String] to which balances will be fetched.
    #
    # @return [OpenStruct(per_currency_balances)]
    def balances(account_id)
      QuestradeApi::REST::Balance.fetch(authorization, account_id)
    end

    def executions(account_id, params = {})
      QuestradeApi::REST::Execution.fetch(authorization, account_id, params)
    end

    def activities(account_id, params = {})
      QuestradeApi::REST::Activity.fetch(authorization, account_id, params)
    end

    def orders(account_id, params = {})
      QuestradeApi::REST::Order.fetch(authorization, account_id, params)
    end
  end
end
