require "httparty"
require "uri"
require "walmart_open/errors"

module WalmartOpen
  class Request
    attr_reader :path, :params

    def submit(client)
      raise "@path must be specified" unless path

      response = HTTParty.public_send(request_method, build_url(client), request_options(client))
      verify_response(response)
      parse_response(response)
    end

    private

    attr_writer :path, :params

    def request_method
      :get
    end

    def build_url(client)
      raise NotImplementedError, "build_url must be implemented by subclass"
    end

    def build_params(client)
      # noop
    end

    def request_options(client)
      {}
    end

    # Subclasses can override this method to return a different response.
    def parse_response(response)
      response
    end

    def verify_response(response)
      unless response.success?
        raise WalmartOpen::AuthenticationError, response.parsed_response.inspect
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
