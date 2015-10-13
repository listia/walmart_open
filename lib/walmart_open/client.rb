require "walmart_open/config"
require "walmart_open/connection_manager"
require "walmart_open/requests/search"
require "walmart_open/requests/lookup"
require "walmart_open/requests/upc_lookup"
require "walmart_open/requests/taxonomy"
require "walmart_open/requests/feed"

module WalmartOpen
  class Client
    attr_reader :connection
    attr_reader :config

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

    def upc_lookup(upc)
      connection.request(Requests::UpcLookup.new(upc))
    end

    def taxonomy
      connection.request(Requests::Taxonomy.new)
    end

    def feed(type, category_id = nil)
      params = {}
      params[:category_id] = category_id if category_id
      connection.request(Requests::Feed.new(type, params))
    end
  end
end
