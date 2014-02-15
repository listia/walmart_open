require "spec_helper"
require "walmart_open/request"
require "walmart_open/client"
require "walmart_open/errors"

describe WalmartOpen::Request do
  class DummyRequest < WalmartOpen::Request
    attr_accessor :fake_url,
                  :fake_request_options

    def initialize
      @path = "dummy"
      @fake_url = "http://example.com/foo/bar/path?q1=true"
      @fake_request_options = {dummy_option: true}
    end

    def build_url(client)
      @fake_url
    end

    def request_options(client)
      @fake_request_options
    end

    def unset_path!
      @path = nil
    end

    public :request_method
  end

  context "#submit" do
    let(:client) { WalmartOpen::Client.new }
    let(:request) { DummyRequest.new }
    let(:response) { double(success?: true, parsed_response: {}) }

    before do
      allow(HTTParty).to receive(request.request_method).with(request.fake_url, request.fake_request_options).and_return(response)
    end

    context "when path is set" do
      it "uses HTTParty to make the request" do
        expect(HTTParty).to receive(request.request_method).with(request.fake_url, request.fake_request_options).and_return(response)

        request.submit(client)
      end

      context "when response is success" do
        it "returns the response" do
          expect(request.submit(client)).to eq(response)
        end
      end

      context "when response is not success" do
        before do
          allow(response).to receive(:success?).and_return(false)
        end

        it "raises an error" do
          expect {
            request.submit(client)
          }.to raise_error(WalmartOpen::ServerError)
        end
      end
    end

    context "when path is not set" do
      before do
        request.unset_path!
      end

      it "raises an error" do
        expect {
          request.submit(client)
        }.to raise_error("@path must be specified")
      end
    end
  end
end
