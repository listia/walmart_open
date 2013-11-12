require "httparty"

module WalmartOpen
  class Request
    attr_reader :path
    attr_reader :params

    def submit(config)
      parse_response(HTTParty.public_send(request_method, config.build_url(type, path, params), request_options(config)))
    end

    def type
      @type || :product
    end

    def request_method
      @request_method || :get
    end

    private

    def request_options(config)
      { verify: false }
    end

    # Subclasses can override this method to return a different response.
    def parse_response(response)
      response
    end
  end
end
