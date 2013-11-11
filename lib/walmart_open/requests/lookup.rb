module WalmartOpen
  module Requests
    class Search < Request
      def initialize(item_id, params = {})
        @path = "items/#{item_id}"
        @params = params
      end

      private

      def parse_response(response)
      end
    end
  end
end
