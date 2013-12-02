require "spec_helper"
require "walmart_open/connection_manager"
require "walmart_open/client"
require "walmart_open/product_request"


describe WalmartOpen::ConnectionManager do
  context "product request" do
    it "#trottle sleep not happened" do
      t1 = Time.now
      client = WalmartOpen::Client.new({product_calls_per_second: 1})
      connection = WalmartOpen::ConnectionManager.new(client)
      request_object = double
      expect(connection).to receive(:request_type).at_least(:once).and_return(:product)
      expect(request_object).to receive(:submit).at_least(:once).and_return("")

      connection.request(request_object)

      t2 = Time.now
      expect(t2-t1).to be <= 1
    end

    it "#trottle sleep happened" do
      t1 = Time.now
      client = WalmartOpen::Client.new({product_calls_per_second: 1})
      connection = WalmartOpen::ConnectionManager.new(client)
      request_object = double
      expect(connection).to receive(:request_type).at_least(:once).and_return(:product)
      expect(request_object).to receive(:submit).at_least(:once).and_return("")

      connection.request(request_object)  # request twice in one second
      connection.request(request_object)

      t2 = Time.now
      expect(t2-t1).to be >= 1
    end
  end

  context "commerce request" do
    it "#trottle sleep not happened" do
      t1 = Time.now
      client = WalmartOpen::Client.new({commerce_calls_per_second: 1})
      connection = WalmartOpen::ConnectionManager.new(client)
      request_object = double
      expect(connection).to receive(:request_type).at_least(:once).and_return(:commerce)
      expect(request_object).to receive(:submit).at_least(:once).and_return("")

      connection.request(request_object)

      t2 = Time.now
      expect(t2-t1).to be <= 1
    end

    it "#trottle sleep happened" do
      t1 = Time.now
      client = WalmartOpen::Client.new({commerce_calls_per_second: 1})
      connection = WalmartOpen::ConnectionManager.new(client)
      request_object = double
      expect(connection).to receive(:request_type).at_least(:once).and_return(:commerce)
      expect(request_object).to receive(:submit).at_least(:once).and_return("")

      connection.request(request_object)   # request twice in one second
      connection.request(request_object)

      t2 = Time.now
      expect(t2-t1).to be >= 1
    end
  end


end


