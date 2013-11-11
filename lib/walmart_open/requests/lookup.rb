require "walmart_open/request"

module WalmartOpen
  module Requests
    class Lookup < Request
      def initialize(item_id, params = {})
        @path = "items/#{item_id}"
        @params = params
      end

      private

      def parse_response(response)
        response
      end
    end
  end
end
