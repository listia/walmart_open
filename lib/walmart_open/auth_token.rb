module WalmartOpen
  class AuthToken
    attr_reader :token_type,
                :access_token,
                :time,
                :expiration_time

    def initialize(attrs, grant_time = Time.now)
      @expiration_time = grant_time + attrs["expires_in"] if attrs["expires_in"]  # attrs[:expires_in] can be null if response is {"error"=>"invalid_client"}
      @token_type = attrs["token_type"]
      @access_token = attrs["access_token"]
      @time = grant_time
    end

    def expired?
      buffer = 30 # seconds
      return false if expiration_time.nil?
      Time.now + buffer >= expiration_time
    end

    def authorization_header
      "#{token_type} #{access_token}"
    end
  end
end
