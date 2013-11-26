require "walmart_open/commerce_request"
require "walmart_open/order_xml_builder"
require "walmart_open/order_results"
require "walmart_open/order_error"
require "walmart_open/authentication_error"
require "openssl"
require "base64"


module WalmartOpen
  module Requests
    class PlaceOrder < CommerceRequest
      attr_accessor :order

      def initialize(order)
        self.path = "orders/place"
        @order = order
      end

      private

      def parse_response(response)
        OrderResults.new(response.parsed_response)
      end

      def verify_response(response)
        unless response.success?
          if response.code == 400
            raise WalmartOpen::OrderError, response.parsed_response.inspect
          else
            raise WalmartOpen::AuthenticationError, response.parsed_response.inspect
          end
        end
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
        OrderXMLBuilder.new(order).build
      end

      def sign(key, data)
        Base64.urlsafe_encode64(key.sign(OpenSSL::Digest::SHA256.new, data))
      end
    end
  end
end
