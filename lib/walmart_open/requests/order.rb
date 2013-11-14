require "walmart_open/commerce_request"
require "walmart_open/order_xsd_builder"
require "openssl"
require "base64"

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
        body = build_xsd
        signature = client.config.debug ? "FAKE_SIGNATURE" : sign(client.config.private_key, body)

        {
          headers: {
            "Authorization" => client.auth_token.authorization_header,
            "Content-Type" => "text/xml",
            "X-Walmart-Body-Signature" => signature
          },
          body: body
        }
      end

      def build_params(client)
        { disablesigv: true } if client.config.debug
      end

      def build_xsd
        OrderXSDBuilder.new.build
      end

      def sign(key, data)
        Base64.urlsafe_encode64(key.sign(OpenSSL::Digest::SHA256.new, data))
      end
    end
  end
end
