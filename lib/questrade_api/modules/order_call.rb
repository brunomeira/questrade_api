require 'questrade_api/rest/order'

module QuestradeApi
  module OrderCall
    def create_order(account_id, params = {})
      QuestradeApi::REST::Order.create(authorization, account_id, params)
    end
  end
end
