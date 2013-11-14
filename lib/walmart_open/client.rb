require "walmart_open/config"
require "walmart_open/request_manager"
require "walmart_open/requests/search"
require "walmart_open/requests/lookup"
require "walmart_open/requests/taxonomy"
require "walmart_open/requests/oauth_token"
require "walmart_open/requests/order"

module WalmartOpen
  class Client
    attr_reader :manager
    attr_reader :config

    def initialize(config_attrs = {})
      @config = Config.new(config_attrs)
      @manager = RequestManager.new(self)

      @commerce_token = nil

      yield config if block_given?
    end

    def search(query, params = {})
      manager.request(Requests::Search.new(query, params))
    end

    def lookup(item_id, params = {})
      manager.request(Requests::Lookup.new(item_id, params))
    end

    def taxonomy
      manager.request(Requests::Taxonomy.new)
    end

    def order(item_id)
      if !@commerce_token || @commerce_token.expired?
        @commerce_token = manager.request(Requests::OAuthToken.new)
      end

      #manager.request(Requests::Order.new(item_id, @commerce_token))
    end
  end
end
