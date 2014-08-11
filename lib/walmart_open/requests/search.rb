require "walmart_open/product_request"
require "walmart_open/search_results"

module WalmartOpen
  module Requests
    class Search < ProductRequest
      def initialize(query, params = {})
        self.path = "search"
        self.params = params.merge(query: query)
      end

      private

      def parse_response(response)
        SearchResults.new(response.parsed_response)
      end
    end
  end
end
