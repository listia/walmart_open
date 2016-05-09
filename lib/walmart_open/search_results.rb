require "walmart_open/item"

module WalmartOpen
  class SearchResults
    attr_reader :query,
                :total,
                :items,
                :start,
                :page

    def initialize(response)
      @query = response["query"]
      @total = response["totalResults"]
      @start = response["start"]
      # TODO: set the page!
      # @page = ...

      @items = Array(response["items"]).map { |item| Item.new(item) }
    end
  end
end
