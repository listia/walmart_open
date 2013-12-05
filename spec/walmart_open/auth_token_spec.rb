require "spec_helper"
require "walmart_open/auth_token"
require "timecop"

describe WalmartOpen::AuthToken do
  let(:auth_token_attrs) do
    {
      "token_type"    =>  "bearer",
      "mapi"          =>  "8tbvkxd6gu6zjzp6qbyeewb6",
      "access_token"  =>  "k5pzg6jqtetygmrkm5y6qqnr",
      "expires_in"    =>  600
    }
  end

  let(:auth_token) do
    WalmartOpen::AuthToken.new(auth_token_attrs, Time.now)
  end

  context ".new" do
    it "initializes with attributes" do
      Timecop.freeze(Time.now) do
        expect(auth_token.expiration_time).to eq(Time.now + auth_token_attrs["expires_in"])
        expect(auth_token.token_type).to eq(auth_token_attrs["token_type"])
        expect(auth_token.access_token).to eq(auth_token_attrs["access_token"])
        expect(auth_token.time).to eq(Time.now)
      end
    end
  end

  context "#expired?" do
    it "returns true when auth token has expired" do
      Timecop.freeze(Time.now) do
        auth_token

        Timecop.freeze(Time.now + auth_token_attrs["expires_in"] + WalmartOpen::AuthToken::BUFFER_TIME) do
          expect(auth_token).to be_expired
        end
      end
    end

    it "returns false when auth token has not expired" do
      Timecop.freeze(Time.now) do
        expect(auth_token).not_to be_expired
      end
    end
  end

  context "#authorization_header" do
    it "returns authentication_header" do
      expect(auth_token.authorization_header).to eq("Bearer k5pzg6jqtetygmrkm5y6qqnr")
    end
  end
end
