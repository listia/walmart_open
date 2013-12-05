require "spec_helper"
require "walmart_open/connection_manager"
require "walmart_open/client"
require "walmart_open/product_request"
require "timecop"

describe WalmartOpen::ConnectionManager do
  context "#request" do
    let(:client) do
      WalmartOpen::Client.new(
        product_calls_per_second: 1,
        commerce_calls_per_second: 1
      )
    end

    let(:connection_manager) { client.connection }

    shared_examples "a request" do
      it "does not sleep when under calls per second threshold" do
        expect(request).to receive(:submit).twice
        expect(connection_manager).not_to receive(:sleep)

        Timecop.freeze(Time.now) do
          connection_manager.request(request)

          Timecop.freeze(Time.now + 1) do
            connection_manager.request(request)
          end
        end
      end

      it "sleeps when exceeds calls per second threshold" do
        expect(request).to receive(:submit).at_least(:once)
        expect(connection_manager).to receive(:sleep).with(0.5)

        Timecop.freeze(Time.now) do
          connection_manager.request(request)

          Timecop.freeze(Time.now + 0.5) do
            connection_manager.request(request)
          end
        end
      end
    end

    context "when product request" do
      let(:request) { WalmartOpen::ProductRequest.new }

      include_examples "a request"
    end

    context "when commerce request" do
      let(:request) { WalmartOpen::CommerceRequest.new }

      include_examples "a request"
    end
  end
end
