require "walmart_open/product_request"
require "walmart_open/item"

module WalmartOpen
  module Requests
    class Lookup < ProductRequest
      def initialize(item_id, params = {})
        self.path = "items/#{item_id}"
        self.params = params
      end

      private

      def parse_response(response)
        Item.new(response.parsed_response)
      end
    end
  end
end
