require "walmart_open/product_request"

module WalmartOpen
  module Requests
    class Feed < ProductRequest
      TYPES = [
        :preorder,
        :bestsellers,
        :rollback,
        :clearance,
        :specialbuy
      ]
      CATEGORY_REQUIRED_TYPES = TYPES - [:preorder]

      def initialize(type, params = {})
        unless TYPES.include?(type)
          raise ArgumentError, "Invalid feed type #{type}"
        end

        if !params[:category_id] && CATEGORY_REQUIRED_TYPES.include?(type)
          raise ArgumentError, "Category id param is required for the #{type} feed"
        end

        self.path = "feeds/#{type.to_s}"
        self.params = params
      end

      private

      def parse_response(response)
        response.parsed_response["items"].map do |item_hash|
          Item.new(item_hash)
        end
      end
    end
  end
end
