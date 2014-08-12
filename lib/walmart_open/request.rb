require "httparty"
require "uri"
require "walmart_open/errors"

module WalmartOpen
  class Request
    attr_accessor :path, :params

    def submit(client)
      raise "@path must be specified" unless path

      response = HTTParty.public_send(request_method, build_url(client), request_options(client))
      verify_response(response)
      parse_response(response)
    end

    private

    def request_method
      :get
    end

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

    # Subclasses can override this method to return a different response.
    def parse_response(response)
      response
    end

    def verify_response(response)
      unless response.success?
        raise WalmartOpen::ServerError, response.parsed_response.inspect
      end
    end

    def params_to_query_string(params_hash)
      params_hash = convert_param_keys(params_hash || {})
      query_str = URI.encode_www_form(params_hash)
      query_str.prepend("?") unless query_str.size.zero?
      query_str
    end

    # Converts foo_bar_param to fooBarParam.
    def convert_param_keys(underscored_params)
      pairs = underscored_params.map do |key, value|
        key = key.to_s.gsub(/_([a-z])/i) { $1.upcase }
        [key, value]
      end
      Hash[pairs]
    end
  end
end
