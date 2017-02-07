require 'faraday'
require 'json'

require 'questrade_api/modules/util'

module QuestradeApi
  # @author Bruno Meira <goesmeira@gmail.com>
  class Authorization
    include QuestradeApi::Util

    MODE = %i(live practice).freeze
    attr_reader :mode, :data, :connection

    # Initialize an instance of QuestradeApi::Client.
    #
    # @note Only access_token, api_server, and refresh_token are needed for this gem.
    #
    # @param params [Hash] for Questrade authorization.
    # @option params [String] :access_token Access token used to access API.
    # @option params [String] :api_server Endpoint used to access API. Example: 'https://apiXX.iq.questrade.com/', where X is a number.
    # @option params [Integer] :expires_in How much time the access token is valid.
    # @option params [String] :refresh_token Token used to get a new access token.
    # @option params [String] :token_type Token type.
    #
    # @param mode [Symbol] accessed on Questrade, `:live` or `:practice`
    def initialize(params, mode = :practice)
      raise 'Mode must be :live or :practice' unless MODE.include?(mode)

      @mode = mode
      @connection = build_connection

      build_data(params)
    end

    # Uses refresh_token to fetch a new valid access token.
    #
    # @note #data will be populated accordingly, if call is successful.
    #
    # @return The result of the call.
    def refresh_token
      response = connection.get do |req|
        req.params[:grant_type] = 'refresh_token'
        req.params[:refresh_token] = data.refresh_token
      end

      if response.status == 200
        raw_body = JSON.parse(response.body)
        build_data(raw_body)
      end

      response
    end

    # Returns the authorized access token.
    def access_token
      data.access_token
    end

    # Returns the server associated with the authorized access token.
    def url
      data.api_server
    end

    # Checks if selected mode is live.
    #
    # @return [Boolean]
    def live?
      mode == :live
    end

    private

    def login_url
      if live?
        'https://login.questrade.com/oauth2/token'
      else
        'https://practicelogin.questrade.com/oauth2/token'
      end
    end

    def build_data(data)
      hash = hash_to_snakecase(data)
      @data = OpenStruct.new(hash)
    end

    def build_connection
      Faraday.new(login_url) do |faraday|
        faraday.response :logger
        faraday.adapter Faraday.default_adapter
        faraday.headers['Content-Type'] = 'application/json'
      end
    end
  end
end
