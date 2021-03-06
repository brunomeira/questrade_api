require 'questrade_api/rest/base'

module QuestradeApi
  module REST
    # @author Bruno Meira <goesmeira@gmail.com>
    class Activity < QuestradeApi::REST::Base
      attr_accessor :account_id

      def initialize(params)
        @account_id = params[:account_id]

        @raw_body = params[:data]
        build_data(params[:data]) if @raw_body
      end

      #
      # Fetch account activities
      #
      # @param authorization [QuestradeApi::Authorization] with the authorized #access_token and #url.
      # @param account_number [String] with the account the activities will be fetched
      # @param params [Hash] with the range of dates the activities will be fetched
      # @option params [String] :startTime The start time. ex: '2011-02-16T00:00:00.000000-05:00'
      # @option params [String] :endTime The end time. ex: '2011-02-16T00:00:00.000000-05:00'
      def self.fetch(authorization, account_number, params)
        response = super(access_token: authorization.access_token,
                         endpoint: endpoint(account_number),
                         url: authorization.url,
                         params: params)

        result = OpenStruct.new(activities: [])

        if response.status == 200
          result.activities = parse_activities(account_number, response.body)
        end

        result
      end

      def self.endpoint(account_id)
        "#{BASE_ENDPOINT}/accounts/#{account_id}/activities"
      end

      def self.parse_activities(account_number, body)
        raw = JSON.parse(body)

        activities = []

        raw['activities'].each do |activity|
          activities << new(account_id: account_number, data: activity)
        end

        activities
      end

      private_class_method :parse_activities
    end
  end
end
