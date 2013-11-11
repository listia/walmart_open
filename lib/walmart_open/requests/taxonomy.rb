module WalmartOpen
  module Requests
    class Search < Request
      def initialize(item_id, params = {})
        @path = "taxonomy"
        @params = params
      end

      private

      def parse_response(response)
      end
    end
  end
end
