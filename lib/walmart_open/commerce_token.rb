module WalmartOpen
  class CommerceToken
    TOKEN_LIFE = 600 # seconds; 10 minutes

    attr_reader :token_type,
                :access_token,
                :time

    def initialize(attrs, grant_time = Time.now)
      @token_type = attrs["token_type"]
      @access_token = attrs["access_token"]
      @time = grant_time
    end

    def expired?
      Time.now - @time >= TOKEN_LIFE
    end

    def authorization_header
      "#{token_type} #{access_token}"
    end
  end
end
