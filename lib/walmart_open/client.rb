require "walmart_open/config"
require "walmart_open/connection_manager"
require "walmart_open/requests/search"
require "walmart_open/requests/lookup"
require "walmart_open/requests/taxonomy"
require "walmart_open/requests/token"
require "walmart_open/requests/place_order"

module WalmartOpen
  class Client
    attr_reader :connection
    attr_reader :config
    attr_reader :auth_token

    def initialize(config_attrs = {})
      @config = Config.new(config_attrs)
      @connection = ConnectionManager.new(self)

      yield config if block_given?
    end

    def search(query, params = {})
      connection.request(Requests::Search.new(query, params))
    end

    def lookup(item_id, params = {})
      connection.request(Requests::Lookup.new(item_id, params))
    end

    def taxonomy
      connection.request(Requests::Taxonomy.new)
    end

    def order(order_info)
      authenticate!

      connection.request(Requests::PlaceOrder.new(order_info))
    end

    private

    def authenticate!
      if !@auth_token || @auth_token.expired?
        @auth_token = connection.request(Requests::Token.new)
      end
    end
  end
end
