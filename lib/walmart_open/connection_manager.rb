module WalmartOpen
  class ConnectionManager
    def initialize(client)
      @client = client
      @calls = {}
    end

    def request(request_obj)
      throttle(request_obj) do
        request_obj.submit(@client)
      end
    end

    private

    def throttle(request_obj)
      type = request_type(request_obj)
      @calls[type] ||= []
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

    def request_type(request_obj)
      case request_obj
        when ProductRequest  then :product
        when CommerceRequest then :commerce
        else raise "Unknown request type"
      end
    end

    def calls_per_second(type)
      @client.config.public_send("#{type}_calls_per_second")
    end
  end
end
