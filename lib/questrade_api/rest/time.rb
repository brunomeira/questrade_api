require 'questrade_api/rest/base'

module QuestradeApi
  module REST
    # @author Bruno Meira <goesmeira@gmail.com>
    class Time < QuestradeApi::REST::Base
      attr_reader :data

      def initialize(authorization)
        super(authorization)
      end

      def get
        response = super

        build_data(raw_body) if raw_body

        response
      end

      def self.endpoint
        "#{BASE_ENDPOINT}/time"
      end
    end
  end
end
