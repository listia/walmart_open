require "walmart_open/item"
require "walmart_open/requests/lookup"

module WalmartOpen
  module Requests
    class UpcLookup < Lookup
      def initialize(upc, params)
        self.path = "items"
        self.params = params.merge(upc: upc)
      end
    end
  end
end
