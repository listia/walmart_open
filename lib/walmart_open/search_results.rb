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

      @items = []

      response["items"].each do |item|
        @items << Item.new(item)
      end
    end
  end
end
