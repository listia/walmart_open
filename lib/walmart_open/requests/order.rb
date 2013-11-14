require "walmart_open/commerce_request"
require "walmart_open/order_xsd_builder"
require "builder"

module WalmartOpen
  module Requests
    class Order < CommerceRequest
      def initialize(item_id)
        self.path = "orders/place"
      end

      private

      def parse_response(response)
        response
      end

      def request_options(client)
        {
          headers: {
            "Authorization" => client.auth_token.authorization_header,
            "Content-Type" => "text/xml",
            "X-Walmart-Body-Signature" => "DIGITAL SIG"
          },
          body: build_xsd
        }
      end

      def build_params(client)
        { disablesigv: true } if client.config.debug
      end

      def build_xsd
        OrderXSDBuilder.new.build
      end
    end
  end
end
