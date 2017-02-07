require 'questrade_api/authorization'
require 'questrade_api/rest/time'
require 'questrade_api/rest/account'
require 'questrade_api/rest/balance'
require 'questrade_api/rest/position'
require 'questrade_api/rest/execution'
require 'questrade_api/rest/activity'
require 'questrade_api/rest/order'

require 'questrade_api/rest/market'

module QuestradeApi
  # @author Bruno Meira <goesmeira@gmail.com>
  class Client
    attr_reader :authorization

    # @see QuestradeApi::Client#initialize for more details
    def initialize(params = {}, mode = :practice)
      @authorization = QuestradeApi::Authorization.new(params, mode)
      refresh_token if refresh_token?
    end

    # Fetches a new access_token. (see QuestradeApi::Authorization#refresh_token)
    def refresh_token
      @authorization.refresh_token
    end

    # Fetch current server time.
    #
    # @return [DateTime] if no issues to call /time endpoint occurs.
    # @return [nil] if current server time cannot be fetched.
    def time
      time = QuestradeApi::REST::Time.new(@authorization)
      time.get

      time.data && time.data.time
    end

    # Fetch all accounts associated with user.
    #
    # @return [Array<QuestradeApi::REST::Account>]
    def accounts
      QuestradeApi::REST::Account.all(@authorization).accounts
    end

    # Fetch all positions associated with account.
    #
    # @param account_id [String] to which positions will be fetched.
    #
    # @return [Array<QuestradeApi::REST::Position>]
    def positions(account_id)
      QuestradeApi::REST::Position.all(@authorization, account_id).positions
    end

    # Fetch all balances associated with account.
    #
    # @param account_id [String] to which balances will be fetched.
    #
    # @return [OpenStruct(per_currency_balances)]
    def balances(account_id)
      QuestradeApi::REST::Balance.all(@authorization, account_id)
    end

    def executions(account_id, params = {})
      QuestradeApi::REST::Execution.all(@authorization, account_id, params)
    end

    def activities(account_id, params = {})
      QuestradeApi::REST::Activity.all(@authorization, account_id, params)
    end

    def orders(account_id, params = {})
      QuestradeApi::REST::Activity.all(@authorization, account_id, params)
    end

    def markets
      QuestradeApi::REST::Market.all(@authorization)
    end

    private

    def refresh_token?
      data = @authorization.data
      data.refresh_token && !data.api_server && !data.access_token
    end
  end
end
