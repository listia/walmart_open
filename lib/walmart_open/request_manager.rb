module WalmartOpen
  class RequestManager
    def initialize(config)
      @config = config
      @calls = {
        product: [],
        commerce: []
      }
    end

    def request(request_obj)
      throttle(request_obj.type) do
        response = request_obj.submit(@config)
      end
    end

    private

    def throttle(type)
      calls = @calls[type]

      now = Time.now
      calls.delete_if { |time| now - time > 1 }

      if calls.size >= calls_per_second(type)
        sleep((calls.first + 1) - now)
      end

      ret_val = yield

      calls << Time.now

      ret_val
    end

    def calls_per_second(type)
      @config.public_send("#{type}_calls_per_second")
    end
  end
end
