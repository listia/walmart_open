require "walmart_open/request"
require "walmart_open/search_results"

module WalmartOpen
  module Requests
    class Search < Request
      def initialize(query, params = {})
        @path = "search"
        @params = params.merge(query: query)
      end

      private

      def parse_response(response)
        SearchResults.new(response.parsed_response)
      end
    end
  end
end
