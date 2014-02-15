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
      CATEGORY_REQUIRED_TYPES = [
        :bestsellers,
        :rollback,
        :clearance,
        :specialbuy
      ]

      def initialize(type, category_id = nil)
        unless TYPES.include?(type)
          raise ArgumentError, "Invalid feed type #{type}"
        end

        if category_id
          self.params = {categoryId: category_id}
        elsif CATEGORY_REQUIRED_TYPES.include?(type)
          raise ArgumentError, "Category id is required for the #{type} feed"
        end

        self.path = "feeds/#{type.to_s}"
      end

      private

      def parse_response(response)
        response.parsed_response["items"]
      end
    end
  end
end
