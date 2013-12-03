require "spec_helper"
require "walmart_open/auth_token"
require "timecop"

describe WalmartOpen::AuthToken do
    before do
      @grant_time = "Sun, 01 Dec 2013 07:25:35 GMT"
        @attrs = {"token_type"=>"bearer", "mapi"=>"8tbvkxd6gu6zjzp6qbyeewb6", "access_token"=>"k5pzg6jqtetygmrkm5y6qqnr", "expires_in"=>600}
        @auth_token = WalmartOpen::AuthToken.new(@attrs,  Time.parse(@grant_time))
    end

    context "#initialize" do
      it "succeeds" do
        expect(@auth_token.expiration_time).to eq(Time.parse(@grant_time) + @attrs["expires_in"])
        expect(@auth_token.token_type).to eq(@attrs["token_type"])
        expect(@auth_token.access_token).to eq(@attrs["access_token"])
        expect(@auth_token.time).to eq(Time.parse(@grant_time))
      end
    end

    context "#expired" do
      it "did not expire" do
        Timecop.freeze(Time.parse(@grant_time)) do
          expect(@auth_token.expired?).to eq(false)
        end
      end
    end

    context "#authorization_header" do
      it "sets authentication_header" do
        expect(@auth_token.authorization_header).to eq("Bearer k5pzg6jqtetygmrkm5y6qqnr")
      end
    end
end
