require "uri"

module WalmartOpen
  class Config
    attr_accessor :product_domain,
                  :product_version,
                  :product_api_key,
                  :product_calls_per_second,
                  :commerce_domain,
                  :commerce_version,
                  :commerce_api_key,
                  :commerce_api_secret,
                  :commerce_calls_per_second

    def initialize(options = {})
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

    def build_url(type, path, params)
      domain  = send("#{type}_domain")
      version = send("#{type}_version")
      params = URI.encode_www_form(prepare_params(type, params))
      url = "https://#{domain}/#{version}/#{path}"
      url << "?#{params}" if params.length > 0

      url
    end

    private

    def prepare_params(type, params)
      params ||= {}

      if type == :product
        params = {
          api_key: product_api_key,
          format: "json"
        }.merge(params)
      end

      pairs = params.map do |key, value|
        key = key.to_s.gsub(/_([a-z])/i) { $1.upcase }
        [key, value]
      end
      Hash[pairs]
    end
  end
end
