require "walmart_open/request"

module WalmartOpen
  class ProductRequest < Request
    private

    def build_url(client)
      url = "https://#{client.config.product_domain}"
      url << "/#{client.config.product_version}"
      url << "/#{path}"
      url << params_to_query_string(build_params(client))
    end

    def build_params(client)
      {
        format: "json",
        api_key: client.config.product_api_key
      }.merge(params || {})
    end

    # Walmart API unofficially supports HTTPS so we rather hit that instead of
    # HTTP. However, their SSL certificate is unverifiable so we have to tell
    # HTTParty not to verify (otherwise it will complain).
    def request_options(client)
      { verify: false }
    end
  end
end
