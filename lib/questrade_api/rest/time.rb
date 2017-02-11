require 'questrade_api/rest/base'

module QuestradeApi
  module REST
    # @author Bruno Meira <goesmeira@gmail.com>
    class Time < QuestradeApi::REST::Base
      attr_reader :data

      def initialize(authorization)
        super(authorization)
      end

      def fetch
        response = super

        if raw_body
          build_data(raw_body)
          data.time = DateTime.parse(data.time)
          response = data.time
        end

        response
      end

      def self.endpoint
        "#{BASE_ENDPOINT}/time"
      end
    end
  end
end
