require "walmart_open/request"

module WalmartOpen
  module Requests
    class Taxonomy < Request
      def initialize
        @path = "taxonomy"
      end

      private

      def parse_response(response)
        response.parsed_response["categories"]
      end
    end
  end
end
