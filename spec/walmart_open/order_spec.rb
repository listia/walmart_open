require "spec_helper"
require "walmart_open/order"

describe WalmartOpen::Order do
  context "create order" do
    let(:order_params) do
      {
        billing_id:         1,
        first_name:         "James",
        last_name:          "Fong",
        partner_order_id:   "42",
        phone:              "606-478-0850",
        partner_order_time: Time.now
      }
    end

    let(:shipping_addr_params) do
      {
        street1:  "Listia Inc, 200 Blossom Ln",
        street2:  "street2 test",
        city:     "Mountain View",
        state:    "CA",
        zipcode:  "94043",
        country:  "USA"
      }
    end

    let(:order) { WalmartOpen::Order.new(order_params) }

    context ".new" do
      it "sets value correctly" do
        expect(order.shipping_address).to be_nil
        expect(order.items).to be_empty
        expect(order.billing_id).to eql(order_params[:billing_id])
        expect(order.first_name).to eql(order_params[:first_name])
        expect(order.last_name).to eql(order_params[:last_name])
        expect(order.phone).to eql(order_params[:phone])
        expect(order.partner_order_id).to eq(order_params[:partner_order_id])
        expect(order.partner_order_time).to eq(order_params[:partner_order_time])
      end

      it "accepts string keys" do
        stringified_order_params = order_params.each_with_object({}) do |pair, obj|
          obj[pair.first.to_s] = pair.last
        end
        WalmartOpen::Order.new(stringified_order_params)

        expect(order.shipping_address).to be_nil
        expect(order.items).to be_empty
        expect(order.billing_id).to eql(order_params[:billing_id])
        expect(order.first_name).to eql(order_params[:first_name])
        expect(order.last_name).to eql(order_params[:last_name])
        expect(order.phone).to eql(order_params[:phone])
        expect(order.partner_order_id).to eq(order_params[:partner_order_id])
        expect(order.partner_order_time).to eq(order_params[:partner_order_time])
      end
    end

    context "#add_shipping_address" do
      it "sets value correctly" do
        order.add_shipping_address(shipping_addr_params)

        expect(order.shipping_address).not_to be_nil
      end
    end

    context "#add_item" do
      it "adds item object" do
        item = double
        order.add_item(item)
        expect(order.items).not_to be_empty
      end

      it "adds item by id" do
        order.add_item(1, 2.0)
        expect(order.items).not_to be_empty
      end
    end
  end

  context "#valid?" do
    let(:valid_attrs) do
      {
        first_name: "James",
        billing_id: 1
      }
    end

    let(:order) do
      WalmartOpen::Order.new(valid_attrs).tap do |order|
        order.add_shipping_address({})
        order.add_item(10371356, 27.94)
      end
    end

    context "when shipping address is valid" do
      before do
        allow(order.shipping_address).to receive(:valid?).and_return(true)
      end

      context "when order attributes are valid" do
        context "when items are valid" do
          it "returns true" do
            expect(order).to be_valid
          end
        end

        context "when items are not valid" do
          before do
            order.add_item(12345)
          end

          it "returns false" do
            expect(order).to_not be_valid
          end
        end
      end

      context "when order attributes are not valid" do
        before do
          order.first_name = nil
        end

        it "returns false" do
          expect(order).to_not be_valid
        end
      end
    end

    context "when shipping address is not valid" do
      before do
        allow(order.shipping_address).to receive(:valid?).and_return(false)
      end

      it "returns false" do
        expect(order).to_not be_valid
      end
    end
  end
end
