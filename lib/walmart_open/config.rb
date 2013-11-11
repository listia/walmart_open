require "uri"

module WalmartOpen
  class Config
    attr_accessor :domain,
                  :version,
                  :product_api_key,
                  :commerce_api_key,
                  :commerce_api_secret,
                  :calls_per_second

    def initialize(options = {})
      self.domain    = "walmartlabs.api.mashery.com"
      self.version   = "v1"
      self.calls_per_second = 5

      options.each do |key, value|
        public_send("#{key}=", value)
      end
    end

    def build_url(path, params)
      "https://#{domain}/#{version}/#{path}?#{URI.encode_www_form(prepare_params(params))}"
    end

    private

    def prepare_params(params)
      params = {
        api_key: product_api_key,
        format: "json"
      }.merge(params || {})

      pairs = params.map do |key, value|
        key = key.to_s.gsub(/_([a-z])/i) { $1.upcase }
        [key, value]
      end
      Hash[pairs]
    end
  end
end
