require "walmart_open/request"
require "walmart_open/commerce_token"

module WalmartOpen
  module Requests
    class OAuthToken < Request
      def initialize
        @path = "oauth2/token"
        @type = :commerce
        @request_method = :post
      end

      private

      def request_options(config)
        {
          basic_auth: {
            username: config.commerce_api_key,
            password: config.commerce_api_secret
          },
          body: {
            grant_type: "client_credentials"
          }
        }
      end

      def parse_response(response)
        CommerceToken.new(response.parsed_response, Time.parse(response.headers["date"]))
      end
    end
  end
end
