require "walmart_open/request"
require "walmart_open/item"
require "walmart_open/errors"

module WalmartOpen
  module Requests
    class Lookup < Request
      def initialize(item_id, params = {})
        self.path = "items/#{item_id}"
        self.params = params
      end

      private

      def parse_response(response)
        Item.new(response.parsed_response)
      end

      def verify_response(response)
        if response.code == 400
          raise WalmartOpen::ItemNotFoundError, response.parsed_response.inspect
        end
        super
      end
    end
  end
end
