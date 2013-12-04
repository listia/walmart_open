require "spec_helper"
require "walmart_open/connection_manager"
require "walmart_open/client"
require "walmart_open/product_request"
require "timecop"

describe WalmartOpen::ConnectionManager do
  context "#request" do
    context "when product request" do
      it "did not sleep as did not exceed calls per second threshold" do
        client = WalmartOpen::Client.new({product_calls_per_second: 1})
        connection = WalmartOpen::ConnectionManager.new(client)
        request_object = WalmartOpen::ProductRequest.new
        expect(request_object).to receive(:submit).and_return("").once
        expect(connection).not_to receive(:sleep)

        connection.request(request_object)
      end

      it "slept due to exceeding calls per second threshold" do
        client = WalmartOpen::Client.new({product_calls_per_second: 1})
        connection = WalmartOpen::ConnectionManager.new(client)
        request_object = WalmartOpen::ProductRequest.new
        expect(request_object).to receive(:submit).and_return("").at_least(:once)
        expect(connection).to receive(:sleep).with(1).twice  # two requests slept

        Timecop.freeze(Time.now) do
          connection.request(request_object)  # request three times in one second
          connection.request(request_object)
          connection.request(request_object)
        end
      end
    end

    context "when commerce request" do
      it "did not sleep as did not exceed calls per second threshold" do
        client = WalmartOpen::Client.new({commerce_calls_per_second: 1})
        connection = WalmartOpen::ConnectionManager.new(client)
        request_object = WalmartOpen::CommerceRequest.new
        expect(request_object).to receive(:submit).and_return("").once
        expect(connection).not_to receive(:sleep)
        connection.request(request_object)
      end

      it "slept due to exceeding calls per second threshold" do
        client = WalmartOpen::Client.new({commerce_calls_per_second: 1})
        connection = WalmartOpen::ConnectionManager.new(client)
        request_object = WalmartOpen::CommerceRequest.new
        expect(request_object).to receive(:submit).and_return("").at_least(:once)
        expect(connection).to receive(:sleep).with(1).twice  # two requests slept

        Timecop.freeze(Time.now) do
          connection.request(request_object)  # request three times in one second
          connection.request(request_object)
          connection.request(request_object)
        end
      end
    end
  end
end


