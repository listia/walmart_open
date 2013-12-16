require "spec_helper"
require "walmart_open/shipping_address"

describe WalmartOpen::ShippingAddress do
  let(:valid_attrs) do
    {
      first_name:   "Testfirstname",
      last_name:    "Testlastname",
      street1:      "Foo Bar, Maple St.",
      street2:      "Apt #100",
      city:         "Mountain View",
      state:        "CA",
      zipcode:      "94043",
      country:      "USA",
      phone:        "1234567"
    }
  end

  let(:shipping_address) { WalmartOpen::ShippingAddress.new(valid_attrs) }

  context ".new" do
    it "sets attributes" do
      WalmartOpen::ShippingAddress::ATTRIBUTES.each do |key|
        expect(shipping_address.public_send(key.to_sym)).to eq(valid_attrs[key])
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

      context "missing optional key" do
        context "when no last name" do
          it "returns true" do
            valid_attrs.delete(:last_name)
            expect(shipping_address).to be_valid
          end
        end

        context "when no street2" do
          it "returns true" do
            valid_attrs.delete(:street2)
            expect(shipping_address).to be_valid
          end
        end
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

      context "missing required first_name" do
        it "returns false" do
          valid_attrs.delete(:first_name)
          expect(shipping_address).not_to be_valid
        end
      end

      context "missing required street1" do
        it "returns false" do
          valid_attrs.delete(:street1)
          expect(shipping_address).not_to be_valid
        end
      end

      context "missing required city" do
        it "returns false" do
          valid_attrs.delete(:city)
          expect(shipping_address).not_to be_valid
        end
      end

      context "missing required state" do
        it "returns false" do
          valid_attrs.delete(:state)
          expect(shipping_address).not_to be_valid
        end
      end

      context "missing required zipcode" do
        it "returns false" do
          valid_attrs.delete(:zipcode)
          expect(shipping_address).not_to be_valid
        end
      end

      context "missing required country" do
        it "returns false" do
          valid_attrs.delete(:country)
          expect(shipping_address).not_to be_valid
        end
      end

      context "missing required phone" do
        it "returns false" do
          valid_attrs.delete(:phone)
          expect(shipping_address).not_to be_valid
        end
      end
    end
  end
end
