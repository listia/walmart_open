require "spec_helper"
require "walmart_open/order"

describe WalmartOpen::Order do
  context "initialize" do
    before do
      @params =  {:billing_id=>1, :first_name=>"James", :last_name=>"Fong", :partner_order_id=>"42", :phone=>"606-478-0850", :partner_order_time => Time.now}
      @order = WalmartOpen::Order.new(@params)
    end

    it "initialize successfully" do
      expect(@order.shipping_address).to be_nil
      expect(@order.items).to be_empty
      expect(@order.billing_id).to eql(@params[:billing_id])
      expect(@order.first_name).to eql(@params[:first_name])
      expect(@order.last_name).to eql(@params[:last_name])
      expect(@order.phone).to eql(@params[:phone])
      expect(@order.partner_order_id).to eq(@params[:partner_order_id])
      expect(@order.partner_order_time).to eq(@params[:partner_order_time])
    end

    it "add shipping_address" do
      params =  {:street1=>"Listia Inc, 200 Blossom Ln", :street2=>"street2 test", :city=>"Mountain View", :state=>"CA", :zipcode=>"94043", :country=>"USA"}
      @order.add_shipping_address(params)

      expect(@order.shipping_address).not_to be_nil
    end

    context "add item" do
      it "add item object" do
        item = double
        @order.add_item(item)
        expect(@order.items).not_to be_empty
      end

      it "add item detail" do
        @order.add_item(1, 2.0)
        expect(@order.items).not_to be_empty
      end
    end
  end


  context "is order valid" do
    it "when required fields are provided" do
      order = WalmartOpen::Order.new({billing_id: 1, first_name: "James"})
      order.add_shipping_address({street1: "Listia Inc, 200 Blossom Ln", city: "Mountain View", state: "CA", zipcode: "94043", country: "USA"})
      order.add_item(10371356, 27.94)
      order.add_item(25174174, 214.99)
      expect(order).to be_valid
    end

    it "when required billing_id not provided" do
      order = WalmartOpen::Order.new({first_name: "James"})
      order.add_shipping_address({street1: "Listia Inc, 200 Blossom Ln", city: "Mountain View", state: "CA", zipcode: "94043", country: "USA"})
      order.add_item(10371356, 27.94)
      order.add_item(25174174, 214.99)
      expect(order).to_not be_valid
    end

    it "when required first_name not provided" do
      order = WalmartOpen::Order.new({billing_id: 1})
      order.add_shipping_address({street1: "Listia Inc, 200 Blossom Ln", city: "Mountain View", state: "CA", zipcode: "94043", country: "USA"})
      order.add_item(10371356, 27.94)
      order.add_item(25174174, 214.99)
      expect(order).to_not be_valid
    end

    it "when required street1 not provided" do
      order = WalmartOpen::Order.new({billing_id: 1, first_name: "James"})
      order.add_shipping_address({city: "Mountain View", state: "CA", zipcode: "94043", country: "USA"})
      order.add_item(10371356, 27.94)
      order.add_item(25174174, 214.99)
      expect(order).to_not be_valid
    end

    it "when required city not provided" do
      order = WalmartOpen::Order.new({billing_id: 1, first_name: "James"})
      order.add_shipping_address({street1: "Listia Inc, 200 Blossom Ln", state: "CA", zipcode: "94043", country: "USA"})
      order.add_item(10371356, 27.94)
      order.add_item(25174174, 214.99)
      expect(order).to_not be_valid
    end

    it "when required state not provided" do
      order = WalmartOpen::Order.new({billing_id: 1, first_name: "James"})
      order.add_shipping_address({street1: "Listia Inc, 200 Blossom Ln", city: "Mountain View", zipcode: "94043", country: "USA"})
      order.add_item(10371356, 27.94)
      order.add_item(25174174, 214.99)
      expect(order).to_not be_valid
    end

    it "when required zipcode not provided" do
      order = WalmartOpen::Order.new({billing_id: 1, first_name: "James"})
      order.add_shipping_address({street1: "Listia Inc, 200 Blossom Ln", city: "Mountain View", state: "CA", country: "USA"})
      order.add_item(10371356, 27.94)
      order.add_item(25174174, 214.99)
      expect(order).to_not be_valid
    end

    it "when required country not provided" do
      order = WalmartOpen::Order.new({billing_id: 1, first_name: "James"})
      order.add_shipping_address({street1: "Listia Inc, 200 Blossom Ln", city: "Mountain View", state: "CA", zipcode: "94043", country: "USA"})

      expect(order).to_not be_valid
    end

  end
end
