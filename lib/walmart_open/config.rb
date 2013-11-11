require "uri"

module WalmartOpen
  class Config
    attr_accessor :domain,
                  :version,
                  :api_key

    def initialize(options = {})
      self.domain    = "walmartlabs.api.mashery.com"
      self.version   = "v1"

      options.each do |key, value|
        public_send("#{key}=", value)
      end
    end

    def build_url(path, params)
      "https://#{domain}/#{version}/#{path}?#{URI.encode_www_form(prepare_params(params))}"
    end

    private

    def prepare_params(params)
      params = (params || {}).reverse_merge(
        api_key: api_key,
        format: "json"
      )

      pairs = params.map do |key, value|
        key = key.to_s.gsub(/_([a-z])/i) { $1.upcase }
        [key, value]
      end
      Hash[pairs]
    end
  end
end
