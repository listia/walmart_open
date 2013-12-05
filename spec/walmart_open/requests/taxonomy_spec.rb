require "spec_helper"
require "walmart_open/requests/taxonomy"
require "walmart_open/client"
require "walmart_open/errors"

describe WalmartOpen::Requests::Taxonomy do
  context "#submit" do
    let(:client) {WalmartOpen::Client.new}
    let(:taxonomy_req) { WalmartOpen::Requests::Taxonomy.new }
    let(:success_response) { double('success_response', success?: true) }
    let(:fail_response) { double('fail_response', success?: false) }
    let(:category_attrs) do
      {
        "categories" => [{
          "id" => "5438",
          "name" => "Apparel",
          "path" => "Apparel",
          "children" => [{
             "id" => "5438_426265",
             "name" => "Accessories",
             "path" => "Apparel/Accessories",
             "children" => [
              {
                "id" => "5438_426265_1043621",
                "name" => "Bandanas",
                "path" => "Apparel/Accessories/Bandanas"
              },
              {
                "id" => "2636_1104695_1105670",
                "name" => "Xbox One Games",
                "path" => "Video Games/Xbox One/Xbox One Games"
              }
            ]
          }]
        }]
      }
    end

    context "when response is success" do
      before do
        allow(success_response).to receive(:parsed_response).and_return(category_attrs)
        allow(HTTParty).to receive(:get).and_return(success_response)
      end

      it "succeeds" do
        taxonomy = taxonomy_req.submit(client)

        expect(taxonomy).to eq(category_attrs["categories"])
      end
    end

    context "when response is not success" do
      before do
        allow(fail_response).to receive(:parsed_response).and_return({
          "errors"=>[{
            "code"=>403,
            "message"=>"Account Inactive"
          }]
        })
      end

      it "raise authentication error" do
        expect{
          taxonomy_req.submit(client)
        }.to raise_error(WalmartOpen::AuthenticationError)
      end
    end
  end
end
