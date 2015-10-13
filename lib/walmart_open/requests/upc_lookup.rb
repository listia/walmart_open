require "walmart_open/request"
require "walmart_open/item"
require "walmart_open/errors"

module WalmartOpen
  module Requests
    class UpcLookup < Lookup
      def initialize(upc)
        self.path = "items"
        self.params = {upc: upc}
      end
    end
  end
end
