module WalmartOpen
  class RequestManager
    def initialize(config)
      @config = config
      @calls = []
    end

    def request(request_obj)
      throttle do
        response = request_obj.submit(@config)
      end
    end

    def throttle
      now = Time.now
      @calls.delete_if { |time| now - time > 1 }

      if @calls.size >= @config.calls_per_second
        sleep((@calls.first + 1) - now)
      end

      ret_val = yield

      @calls << Time.now

      ret_val
    end
  end
end
