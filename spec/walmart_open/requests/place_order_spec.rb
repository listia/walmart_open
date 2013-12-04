require "spec_helper"
require "walmart_open/requests/place_order"
require "walmart_open/order"
require "walmart_open/client"
require "walmart_open/errors"

describe WalmartOpen::Requests::PlaceOrder do
  context "#submit" do
    before do
      order = WalmartOpen::Order.new({billing_id: 1, first_name: "James",
                                      last_name: "Fong", partner_order_id: "44",
                                      phone: "606-478-0850"
                                     }) # partner_order_time: "16:15:47"
      order.add_shipping_address({street1: "Listia Inc, 200 Blossom Ln", street2: "street2 test", city: "Mountain View", state: "CA", zipcode: "94043", country: "USA"})
      order.add_item(20658394, 12.99, 4.97, 1)
      @req_token = WalmartOpen::Requests::Token.new
      @order_req = WalmartOpen::Requests::PlaceOrder.new(order)
      expect(@order_req).to receive(:request_options).and_return({})
      @client = WalmartOpen::Client.new do |config|
        ## Product API
        config.product_api_key = "123"

        # This value defaults to 5.
        ## Commerce API
        config.commerce_api_key = "123"
        config.commerce_api_secret = "456"

        config.debug = true
      end
      @response = double
      expect(HTTParty).to receive(:public_send).and_return(@response)
    end

    it "succeeds with multiple orders" do
      expect(@response).to receive(:success?).and_return(true)
      @attrs = {"response"=>{"orderId"=>"2677911169085",
                              "partnerOrderId"=>"8",
                              "items"=>{"item"=>[{"itemId"=>"25174174",
                                                  "quantity"=>"1", "itemPrice"=>"214.99"},
                                                 {"itemId"=>"10371356", "quantity"=>"1",
                                                  "itemPrice"=>"22.97"}]},
                              "total"=>"259.38", "itemTotal"=>"237.96", "shipping"=>"0", "salesTax"=>"21.42", "surcharge"=>"0.00"}}
      expect(@response).to receive(:parsed_response).and_return(@attrs)
      order = @order_req.submit(@client)

      expect(order.raw_attributes).to eq(@attrs)
    end

    it "succeeds with one order" do
      expect(@response).to receive(:success?).and_return(true)
      @attrs = {"response"=>{"orderId"=>"2677913310915", "partnerOrderId"=>"20", "items"=>{"item"=>{"itemId"=>"10371356", "quantity"=>"1", "itemPrice"=>"22.97"}}, "total"=>"29.95", "itemTotal"=>"22.97", "shipping"=>"4.97", "salesTax"=>"2.01", "surcharge"=>"0.00"}}
      expect(@response).to receive(:parsed_response).and_return(@attrs)
      order = @order_req.submit(@client)

      expect(order.raw_attributes).to eq(@attrs)
    end


    it "fails with 400" do
      expect(@response).to receive(:success?).and_return(false)
      expect(@response).to receive(:code).and_return(400)
      expect(@response).to receive(:parsed_response).and_return({"errors"=>{"error"=>{"code"=>"10020", "message"=>"This order has already been executed"}}})

      expect{@order_req.submit(@client)}.to raise_error(WalmartOpen::OrderError)
    end

    it "fails with 403" do
      expect(@response).to receive(:success?).and_return(false)
      expect(@response).to receive(:code).and_return(403)
      expect(@response).to receive(:parsed_response).and_return({"errors"=>[{"code"=>403, "message"=>"Account Inactive"}]})

      expect{@order_req.submit(@client)}.to raise_error(WalmartOpen::AuthenticationError)
    end
  end
end
