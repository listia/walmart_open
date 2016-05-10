require "walmart_open/request"

module WalmartOpen
  module Requests
    class Trends < Request
      def initialize
        self.path = "trends"
      end

      private

      def parse_response(response)
        response.parsed_response["items"].map do |item_hash|
          Item.new(item_hash)
        end
      end
    end
  end
end
