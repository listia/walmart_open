require "spec_helper"
require "walmart_open/shipping_address"

describe WalmartOpen::ShippingAddress do
  let(:valid_attrs) do
    {
      street1: "Foo Bar, Maple St.",
      street2: "Apt #100",
      city: "Mountain View",
      state: "CA",
      zipcode: "94043",
      country: "USA"
    }
  end

  let(:required_attrs) do
    [
      :street1,
      :city,
      :state,
      :zipcode,
      :country
    ]
  end

  context ".new" do
    it "sets attributes" do
      shipping_address = WalmartOpen::ShippingAddress.new(valid_attrs)

      WalmartOpen::ShippingAddress::ATTRIBUTES.each do |attr|
        expect(shipping_address.public_send(attr)).to eq(valid_attrs[attr])
      end
    end

    it "accepts string keys" do
      stringified_valid_attrs = valid_attrs.each_with_object({}) do |pair, obj|
        obj[pair.first.to_s] = pair.last
      end
      shipping_address = WalmartOpen::ShippingAddress.new(stringified_valid_attrs)

      WalmartOpen::ShippingAddress::ATTRIBUTES.each do |attr|
        expect(shipping_address.public_send(attr)).to eq(valid_attrs[attr])
      end
    end
  end

  context "#valid?" do
    context "when valid" do
      it "returns true" do
        shipping_address = WalmartOpen::ShippingAddress.new(valid_attrs)

        expect(shipping_address).to be_valid
      end

      it "returns true for no street2" do
        valid_attrs.delete(:street2)
        shipping_address = WalmartOpen::ShippingAddress.new(valid_attrs)

        expect(shipping_address).to be_valid
      end
    end

    context "when not valid" do
      it "returns false for missing required attributes" do
        required_attrs.each do |required_attr|
          attrs = valid_attrs.reject { |k, _| k == required_attr }
          expect(WalmartOpen::ShippingAddress.new(attrs)).to_not be_valid
        end
      end
    end
  end
end
