require "walmart_open/request"
require "walmart_open/item"

module WalmartOpen
  module Requests
    class Lookup < Request
      def initialize(item_id, params = {})
        @path = "items/#{item_id}"
        @params = params
      end

      private

      def parse_response(response)
        Item.new(response.parsed_response)
      end
    end
  end
end
