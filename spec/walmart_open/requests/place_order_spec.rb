require "spec_helper"
require "walmart_open/requests/place_order"
require "walmart_open/order"
require "walmart_open/client"
require "walmart_open/errors"

describe WalmartOpen::Requests::PlaceOrder do
  context "#submit" do
    let(:order_attrs) do
      {
        billing_id: 1,
        first_name: "James",
        last_name: "Fong",
        partner_order_id: "44",
        phone: "606-478-0850"
      }
    end

    let(:multiple_order_response) do
      {
        "response" => {
            "orderId" => "2677911169085",
            "partnerOrderId" => "8",
            "items" => {
                "item" => [
                    {
                        "itemId" => "25174174",
                        "quantity" => "1",
                        "itemPrice" => "214.99"
                    },
                    {
                        "itemId" => "10371356",
                        "quantity" => "1",
                        "itemPrice" => "22.97"
                    }
                ]
            },
            "total" => "259.38",
            "itemTotal" => "237.96",
            "shipping" => "0",
            "salesTax" => "21.42",
            "surcharge" => "0.00"
        }
      }
    end

    let(:single_order_response) do
      {
        "response" => {
            "orderId" =>  "2677913310915",
            "partnerOrderId" => "20",
            "items" => {
                "item" => {
                    "itemId" => "10371356",
                    "quantity" => "1",
                    "itemPrice" => "22.97"
                }
            },
            "total" => "29.95",
            "itemTotal" => "22.97",
            "shipping" => "4.97",
            "salesTax" => "2.01",
            "surcharge" => "0.00"
        }
      }
    end

    let(:client) { WalmartOpen::Client.new }
    let(:order) { WalmartOpen::Order.new(order_attrs) }
    let(:order_req) { WalmartOpen::Requests::PlaceOrder.new(order) }
    let(:success_response) { double(success?: true) }
    let(:fail_response) { double(success?: false) }

    before do
      allow(order_req).to receive(:request_options).and_return({})
    end

    context "when response is success" do
      before do
        allow(HTTParty).to receive(:post).and_return(success_response)
        allow(success_response).to receive(:code).and_return(200)
      end

      context "when multiple orders" do
        before do
          allow(success_response).to receive(:parsed_response).and_return(multiple_order_response)
        end

        it "return response" do
          order = order_req.submit(client)
          expect(order.raw_attributes).to eq(multiple_order_response)
        end
      end

      context "when one order" do
        before do
          allow(success_response).to receive(:parsed_response).and_return(single_order_response)
        end

        it "return response" do
          order = order_req.submit(client)
          expect(order.raw_attributes).to eq(single_order_response)
        end
      end
    end

    context "when response is not success" do
      before do
        allow(HTTParty).to receive(:post).and_return(fail_response)
      end

      context "response has http code 400" do
        before do
          allow(fail_response).to receive(:code).and_return(400)
          allow(fail_response).to receive(:parsed_response).and_return({
            "errors" => {
                "error" => {
                    "code" => "10020",
                    "message" => "This order has already been executed"
                }
            }
          })
        end

        it "raises order error" do
          expect{order_req.submit(client)}.to raise_error(WalmartOpen::OrderError)
        end
      end

      context "response has http code not 400" do
        before do
          allow(fail_response).to receive(:code).and_return(403)
          allow(fail_response).to receive(:parsed_response).and_return({
            "errors" => [{
            "code" => 403,
            "message" => "Account Inactive"
            }]
          })
        end

        it "raises authentication error" do
          expect {
            order_req.submit(client)
          }.to raise_error(WalmartOpen::AuthenticationError)
        end
      end
    end
  end
end
