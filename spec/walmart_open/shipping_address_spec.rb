require "spec_helper"
require "walmart_open/shipping_address"

describe WalmartOpen::ShippingAddress do

  context "when initialize" do
    it "successfully" do
      attrs = {:street1 => "Listia Inc, 200 Blossom Ln", :street2 => "street2 test", :city => "Mountain View", :state => "CA", :zipcode => "94043", :country => "USA"}
      shipping_address = WalmartOpen::ShippingAddress.new(attrs)

      WalmartOpen::ShippingAddress::API_ATTRIBUTES_MAPPING.each do |key, value|
        expect(shipping_address.send(value)).to eq(attrs[key])
      end
      expect(shipping_address.raw_attributes).to eq(attrs)
      expect(shipping_address.valid?).to eq(true)
    end
  end

end
