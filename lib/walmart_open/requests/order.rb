require "walmart_open/commerce_request"

module WalmartOpen
  module Requests
    class Order < CommerceRequest
      def initialize(item_id, token)
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
