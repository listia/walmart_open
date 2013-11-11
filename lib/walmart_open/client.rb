require "walmart_open/config"
require "walmart_open/request_manager"

module WalmartOpen
  class Client
    attr_reader :request_manager

    def initialize(config_attrs)
      @request_manager = RequestManager.new

      config = Config.new(config_attrs)
      yield config if block_given?
    end

    def search(query, params = {})
      Request.new(
    end

    def taxonomy
    end

    def lookup
    end
  end
end
