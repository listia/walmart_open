module WalmartOpen
  class Config
    attr_accessor :url,
                  :force_ssl,
                  :version,
                  :api_key,
                  :link_share_id

    def initialize(options = {})
      self.domain    = "walmartlabs.api.mashery.com"
      self.force_ssl = false
      self.version   = "v1"

      options.each do |key, value|
        public_send("#{key}=", value)
      end
    end
  end
end
