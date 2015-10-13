require "spec_helper"
require "walmart_open/client"
require "walmart_open/config"
require "walmart_open/requests/search"
require "walmart_open/requests/lookup"
require "walmart_open/requests/taxonomy"
require "walmart_open/requests/feed"

describe WalmartOpen::Client do
  context ".new" do
    context "when block is given" do
      it "yields the config" do
        yielded_config = nil

        client = WalmartOpen::Client.new do |config|
          yielded_config = config
        end

        expect(yielded_config).to be_kind_of(WalmartOpen::Config)
        expect(yielded_config).to eq(client.config)
      end
    end

    context "when block is not given" do
      it "does not complain" do
        client = WalmartOpen::Client.new
      end
    end
  end

  context "#search" do
    it "delegates the request and returns the response" do
      client = WalmartOpen::Client.new
      query = double
      params = double
      request = double

      expect(WalmartOpen::Requests::Search).to receive(:new) do |query_arg, params_arg|
        expect(query_arg).to eq(query)
        expect(params_arg).to eq(params)
        request
      end
      expect(client.connection).to receive(:request).with(request)

      client.search(query, params)
    end
  end

  context "#lookup" do
    it "delegates the request and returns the response" do
      client = WalmartOpen::Client.new
      item_id = double
      params = double
      request = double

      expect(WalmartOpen::Requests::Lookup).to receive(:new) do |item_id_arg, params_arg|
        expect(item_id_arg).to eq(item_id)
        expect(params_arg).to eq(params)
        request
      end
      expect(client.connection).to receive(:request).with(request)

      client.lookup(item_id, params)
    end
  end

  context "#upc_lookup" do
    it 'generates a lookup request for a UPC' do
      client = WalmartOpen::Client.new
      params = double
      request = double
      upc = double

      expect(WalmartOpen::Requests::UpcLookup).to receive(:new) do |upc|
        expect(upc).to eq(upc)
        request
      end
      expect(client.connection).to receive(:request).with(request)

      client.upc_lookup(params)
    end
  end

  context "#taxonomy" do
    it "delegates the request and returns the response" do
      client = WalmartOpen::Client.new
      request = double

      expect(WalmartOpen::Requests::Taxonomy).to receive(:new).and_return(request)
      expect(client.connection).to receive(:request).with(request)

      client.taxonomy
    end
  end

  context "#feed" do
    it "delegates the request and returns the response" do
      client = WalmartOpen::Client.new
      request = double
      type = double
      category_id = double

      expect(WalmartOpen::Requests::Feed).to receive(:new).with(type, { category_id: category_id }).and_return(request)
      expect(client.connection).to receive(:request).with(request)

      client.feed(type, category_id)
    end
  end
end
