module WalmartOpen
  class AuthToken
    BUFFER_TIME = 30 # seconds

    attr_reader :token_type,
                :access_token,
                :time,
                :expiration_time

    def initialize(attrs, grant_time = Time.now)
      @expiration_time = grant_time + attrs["expires_in"]
      @token_type = attrs["token_type"]
      @access_token = attrs["access_token"]
      @time = grant_time
    end

    def expired?
      Time.now + BUFFER_TIME >= expiration_time
    end

    def authorization_header
      "#{token_type.capitalize} #{access_token}"
    end
  end
end
