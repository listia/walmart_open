require "uri"

module WalmartOpen
  class Config
    attr_accessor :debug,
                  :product_domain,
                  :product_version,
                  :product_api_key,
                  :linkshare_publisher_id,
                  :product_calls_per_second

    def initialize(options = {})
      # Default to production mode.
      self.debug = false

      # Set some defaults for Product API.
      self.product_domain    = "walmartlabs.api.mashery.com"
      self.product_version   = "v1"
      self.product_calls_per_second = 5

      options.each do |key, value|
        public_send("#{key}=", value)
      end
    end
  end
end
