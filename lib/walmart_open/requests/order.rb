require "walmart_open/request"

module WalmartOpen
  module Requests
    class Order < Request
      def initialize(item_id, token)
        @type = :commerce
      end

      private

      def request_options(config)
        {}
      end

      def parse_response(response)
        response
      end
    end
  end
end
