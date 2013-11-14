require "walmart_open/product_request"

module WalmartOpen
  module Requests
    class Taxonomy < ProductRequest
      def initialize
        self.path = "taxonomy"
      end

      private

      def parse_response(response)
        response.parsed_response["categories"]
      end
    end
  end
end
