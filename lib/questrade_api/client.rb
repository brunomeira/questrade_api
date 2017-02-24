require 'questrade_api/authorization'

require 'questrade_api/modules/account_call'
require 'questrade_api/modules/market_call'
require 'questrade_api/modules/order_call'

module QuestradeApi
  # @author Bruno Meira <goesmeira@gmail.com>
  class Client
    include QuestradeApi::AccountCall
    include QuestradeApi::MarketCall
    include QuestradeApi::OrderCall

    attr_accessor :authorization

    # @see QuestradeApi::Client#initialize for more details
    def initialize(params = {}, mode = :practice)
      self.authorization = QuestradeApi::Authorization.new(params, mode)
      refresh_token if refresh_token?
    end

    # Fetches a new access_token. (see QuestradeApi::Authorization#refresh_token)
    def refresh_token
      authorization.refresh_token
    end

    private

    def refresh_token?
      data = authorization.data
      data.refresh_token && !data.api_server && !data.access_token
    end
  end
end
