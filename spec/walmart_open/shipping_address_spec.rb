require "spec_helper"
require "walmart_open/shipping_address"

describe WalmartOpen::ShippingAddress do
  let(:valid_attrs) do
    {
      first_name:   "Testfirstname",
      last_name:    "Testlastname",
      street1:      "Foo Bar, Maple St.",
      street2:      "Apt #100",
      "city"    =>  "Mountain View",
      state:        "CA",
      zipcode:      "94043",
      "country" =>  "USA",
      "phone"   =>  "1234567"
    }
  end

  context ".new" do
    it "sets attributes" do
      shipping_address = WalmartOpen::ShippingAddress.new(valid_attrs)

      WalmartOpen::ShippingAddress::ATTRIBUTES.each do |key|
        expect(shipping_address.public_send(key.to_sym)).to eq(valid_attrs[key] || valid_attrs[key.to_s])
      end
    end
  end

  context "#valid?" do
    shared_examples_for "missing optional key" do |optional_key|
      before do
        valid_attrs.delete(optional_key)
      end

      it "returns true" do
        shipping_address = WalmartOpen::ShippingAddress.new(valid_attrs)

        expect(shipping_address).to be_valid
      end
    end

    context "when valid" do
      context "when all required field are present" do
        it "returns true" do
          shipping_address = WalmartOpen::ShippingAddress.new(valid_attrs)

          expect(shipping_address).to be_valid
        end
      end

      context "when no last name" do
        it_behaves_like "missing optional key", :last_name
      end

      context "when no street2" do
        it_behaves_like "missing optional key", :street2
      end
    end

    context "when not valid" do
      shared_examples_for "missing required key" do |optional_key|
        before do
          valid_attrs.delete(optional_key) || valid_attrs.delete(optional_key.to_s)
        end

        it "returns false" do
          shipping_address = WalmartOpen::ShippingAddress.new(valid_attrs)

          expect(shipping_address).not_to be_valid
        end
      end

      it_behaves_like "missing required key", :first_name
      it_behaves_like "missing required key", :street1
      it_behaves_like "missing required key", :city
      it_behaves_like "missing required key", :state
      it_behaves_like "missing required key", :zipcode
      it_behaves_like "missing required key", :country
      it_behaves_like "missing required key", :phone
    end
  end
end
