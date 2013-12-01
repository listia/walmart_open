require "spec_helper"
require "walmart_open/requests/token"
require "walmart_open/client"
require "walmart_open/authentication_error"

describe WalmartOpen::Requests::Token do

  context "when submit" do
    before do
      @token_req = WalmartOpen::Requests::Token.new
      @client = WalmartOpen::Client.new
      @response = double
      expect(HTTParty).to receive(:public_send).and_return(@response)
    end

    it "success" do
      expect(@response).to receive(:success?).and_return(true)
      @attrs = {"token_type"=>"bearer", "mapi"=>"8tbvkxd6gu6zjzp6qbyeewb6", "access_token"=>"k5pzg6jqtetygmrkm5y6qqnr", "expires_in"=>600}
      expect(@response).to receive(:parsed_response).and_return(@attrs)
      @header_attrs = {"date"=> "Sun, 01 Dec 2013 07:25:35 GMT"}
      expect(@response).to receive(:headers).and_return(@header_attrs)

      token = @token_req.submit(@client)
      expect(token.token_type).to eq(@attrs["token_type"])
      expect(token.access_token).to eq(@attrs["access_token"])
      expect(token.time).to eq(Time.parse(@header_attrs["date"]))
    end

    it "fails with 403" do
      expect(@response).to receive(:success?).and_return(false)
      expect(@response).to receive(:parsed_response).and_return({"errors"=>[{"code"=>403, "message"=>"Account Inactive"}]})

      expect{@token_req.submit(@client)}.to raise_error(WalmartOpen::AuthenticationError)
    end
  end
end