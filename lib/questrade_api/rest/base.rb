require 'questrade_api/modules/util'
require 'faraday'
require 'json'

module QuestradeApi
  module REST
    # @author Bruno Meira <goesmeira@gmail.com>
    class Base
      include QuestradeApi::Util

      BASE_ENDPOINT = '/v1'.freeze
      attr_accessor :connection, :raw_body, :endpoint,
                    :authorization, :data

      # Initialize an instance of QuestradeApi::REST::Base
      #
      # @param authorization [Object] to access API. Any object that responds to url and access_token.
      def initialize(authorization)
        @authorization = authorization

        # TODO: Review this later
        @connection =
          self.class.connection(url: url,
                                access_token: @authorization.access_token)
      end

      # @return [String]
      def url
        authorization.url
      end

      # Builds a new Faraday connection to access endpoint.
      #
      # @param params [Hash] for connection.
      # @option params [String] :url of endpoint.
      # @option params [String] :access_token to call endpoint.
      #
      # @return [Faraday] Object with attributes set up to call proper endpoint.
      def self.connection(params = {})
        Faraday.new(params[:url]) do |faraday|
 #         faraday.response :logger
          faraday.adapter Faraday.default_adapter
          faraday.headers['Content-Type'] = 'application/json'
          faraday.headers['Authorization'] = "Bearer #{params[:access_token]}"
        end
      end

      protected

      def build_data(data)
        hash = hash_to_snakecase(data)
        @data = OpenStruct.new(hash)
      end

      def build_attributes(response)
        @raw_body = JSON.parse(response.body)
      end

      def fetch(params = {})
        response = @connection.get do |req|
          req.path = params[:endpoint] || self.class.endpoint

          params.fetch(:params, []).each do |key, value|
            req.params[key] = value
          end
        end

        build_attributes(response) if response.status == 200

        response
      end

      class << self
        def fetch(params = {})
          connection = connection(params)

          connection.get do |req|
            req.path = params[:endpoint]

            params.fetch(:params, []).each do |key, value|
              req.params[key] = value
            end
          end
        end
      end
    end
  end
end
