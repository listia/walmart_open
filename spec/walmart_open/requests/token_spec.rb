require "spec_helper"
require "walmart_open/requests/token"
require "walmart_open/client"
require "walmart_open/errors"

describe WalmartOpen::Requests::Token do
  context "#submit" do
    let(:client) {WalmartOpen::Client.new}
    let(:token_req) { WalmartOpen::Requests::Token.new }
    let(:success_response) { double(success?: true) }
    let(:fail_response) { double(success?: false) }

    context "when response is success" do
      before do
        allow(HTTParty).to receive(:post).and_return(success_response)
        attrs = {
          "token_type" => "bearer",
          "mapi" => "8tbvkxd6gu6zjzp6qbyeewb6",
          "access_token" => "k5pzg6jqtetygmrkm5y6qqnr",
          "expires_in" => 600
        }
        allow(success_response).to receive(:parsed_response).and_return(attrs)
        header_attrs = {"date"=> "Sun, 01 Dec 2013 07:25:35 GMT"}
        allow(success_response).to receive(:headers).and_return(header_attrs)
      end

      it "get response" do
        token = token_req.submit(client)

        expect(token.token_type).to eq("bearer")
        expect(token.access_token).to eq("k5pzg6jqtetygmrkm5y6qqnr")
        expect(token.time).to eq(Time.parse("Sun, 01 Dec 2013 07:25:35 GMT"))
      end
    end

    context "when response is not success" do
      before do
        allow(HTTParty).to receive(:post).and_return(fail_response)
        allow(fail_response).to receive(:parsed_response).and_return({"errors"=>[{"code"=>403, "message"=>"Account Inactive"}]})
      end

      it "get authentication error" do
        expect{
          token_req.submit(client)
        }.to raise_error(WalmartOpen::AuthenticationError)
      end
    end
  end
end
