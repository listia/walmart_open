module WalmartOpen
  class RequestManager
    def initialize(config)
      @config = config
    end

    def request(request_obj)
      request_obj.submit(@config)
    end
  end
end
