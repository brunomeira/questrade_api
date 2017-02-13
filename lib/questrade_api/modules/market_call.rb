require 'questrade_api/rest/market'
require 'questrade_api/rest/symbol'
require 'questrade_api/rest/quote'
require 'questrade_api/rest/candle'
require 'questrade_api/rest/option'

module QuestradeApi
  module MarketCall
    def markets
      QuestradeApi::REST::Market.fetch(authorization)
    end

    def symbols(params)
      QuestradeApi::REST::Symbol.fetch(authorization, params)
    end

    def symbol(id)
      symbol = QuestradeApi::REST::Symbol.new(authorization, id: id)
      symbol.fetch

      symbol
    end

    def search_symbols(params)
      QuestradeApi::REST::Symbol.search(authorization, params)
    end

    def quotes(ids)
      QuestradeApi::REST::Quote.fetch(authorization, ids)
    end

    def quote(id)
      quote =
        QuestradeApi::REST::Quote.new(authorization: authorization, id: id)

      quote.fetch

      quote
    end

    def candles(symbol_id, params)
      QuestradeApi::REST::Candle.fetch(authorization, symbol_id, params)
    end

    def symbol_options(symbol_id)
      QuestradeApi::REST::Option.fetch(authorization, symbol_id)
    end
  end
end
