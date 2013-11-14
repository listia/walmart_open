require "uri"

module WalmartOpen
  class Config
    attr_accessor :debug,
                  :product_domain,
                  :product_version,
                  :product_api_key,
                  :product_calls_per_second,
                  :commerce_domain,
                  :commerce_version,
                  :commerce_api_key,
                  :commerce_api_secret,
                  :commerce_private_key,
                  :commerce_private_key_password,
                  :commerce_calls_per_second

    def initialize(options = {})
      # Default to production mode.
      self.debug = false

      # Set some defaults for Product API.
      self.product_domain    = "walmartlabs.api.mashery.com"
      self.product_version   = "v1"
      self.product_calls_per_second = 5

      # Set some defaults for Commerce API.
      self.commerce_domain  = "api.walmartlabs.com"
      self.commerce_version = "v1"
      self.commerce_calls_per_second = 2

      options.each do |key, value|
        public_send("#{key}=", value)
      end
    end

    def private_key
      @private_key ||= OpenSSL::PKey.read(commerce_private_key, commerce_private_key_password)
    end
  end
end
