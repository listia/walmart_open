module WalmartOpen
  class ConnectionManager
    def initialize(client)
      @client = client
      @calls = []
    end

    def request(request_obj)
      throttle(request_obj) do
        request_obj.submit(@client)
      end
    end

    private

    def throttle(request_obj)
      calls = @calls

      now = Time.now
      calls.delete_if { |time| now.to_f - time.to_f >= 1 }

      if calls.size >= calls_per_second
        sleep((calls.first + 1) - now)
      end

      ret_val = yield

      calls << Time.now

      ret_val
    end

    def calls_per_second
      @client.config.public_send("product_calls_per_second")
    end
  end
end
