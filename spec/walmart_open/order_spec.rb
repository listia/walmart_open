require "spec_helper"
require "walmart_open/order"

describe WalmartOpen::Order do
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
