require "spec_helper"
require "walmart_open/requests/feed"
require "walmart_open/client"
require "walmart_open/errors"

describe WalmartOpen::Requests::Feed do
  let(:client) {WalmartOpen::Client.new}
  let(:success_response) { double(success?: true) }
  let(:fail_response) { double(success?: false) }
  let(:feed_attrs) do
    {
      "items" => [{
                    "id" => "5438",
                    "name" => "Apparel",
                    "path" => "Apparel",
                  }]
    }
  end
  let(:feed_type) { double(:type) }
  let(:category_id) { 1 }

  context ".new" do

    context "when feed type is valid" do
      before do
        WalmartOpen::Requests::Feed::TYPES.stub(:include?).with(feed_type).and_return(true)
      end

      context "when feed type requires category_id" do
        before do
          WalmartOpen::Requests::Feed::CATEGORY_REQUIRED_TYPES.stub(:include?).with(feed_type).and_return(true)
        end

        context "when category_id is provided" do
          it "does not raise error" do
            expect{
              WalmartOpen::Requests::Feed.new(feed_type, category_id)
            }.not_to raise_error
          end
        end

        context "when category_id is not provided" do
          it "does not raise error" do
            expect{
              WalmartOpen::Requests::Feed.new(feed_type)
            }.to raise_error(ArgumentError)
          end
        end
      end

      context "when feed type does not require category_id" do
        before do
          WalmartOpen::Requests::Feed::CATEGORY_REQUIRED_TYPES.stub(:include?).with(feed_type).and_return(false)
        end

        context "when category_id is provided" do
          it "does not raise error" do
            expect{
              WalmartOpen::Requests::Feed.new(feed_type, category_id)
            }.not_to raise_error
          end
        end

        context "when category_id is not provided" do
          it "does not raise error" do
            expect{
              WalmartOpen::Requests::Feed.new(feed_type)
            }.not_to raise_error
          end
        end
      end
    end

    context "when feed type is not valid" do
      before do
        WalmartOpen::Requests::Feed::TYPES.stub(:include?).with(feed_type).and_return(false)
      end

      it "raises error" do
        expect{
          WalmartOpen::Requests::Feed.new(feed_type, category_id)
        }.to raise_error(ArgumentError)
      end
    end
  end

  context "#submit" do
    let(:feed_request) { WalmartOpen::Requests::Feed.new(feed_type, category_id) }

    before do
      WalmartOpen::Requests::Feed::TYPES.stub(:include?).with(feed_type).and_return(true)
      WalmartOpen::Requests::Feed::CATEGORY_REQUIRED_TYPES.stub(:include?).with(feed_type).and_return(true)
    end

    context "when response is success" do
      before do
        allow(success_response).to receive(:parsed_response).and_return(feed_attrs)
        allow(HTTParty).to receive(:get).and_return(success_response)
      end

      it "succeeds" do
        results = feed_request.submit(client)

        expect(results).to eq(feed_attrs["items"])
      end
    end

    context "when response is not success" do
      before do
        allow(HTTParty).to receive(:get).and_return(fail_response)
        allow(fail_response).to receive(:parsed_response).and_return({
          "errors"=>[{
            "code"=>403,
            "message"=>"Account Inactive"
          }]
        })
      end

      it "raises authentication error" do
        expect{
          feed_request.submit(client)
        }.to raise_error(WalmartOpen::AuthenticationError)
      end
    end
  end
end
