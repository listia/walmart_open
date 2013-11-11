module WalmartOpen
  module Requests
    class Search < Request
      def initialize(query, params = {})
        @path = "search"
        @params = params.merge(query: query)
      end

      private

      def parse_response(response)
        response
      end
    end
  end
end
