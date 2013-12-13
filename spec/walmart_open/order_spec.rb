require "spec_helper"
require "walmart_open/order"

describe WalmartOpen::Order do
  # mix symbol key and string key for testing purpose
  let(:basic_order_params) do
    {
        billing_record_id:       1,
        partner_order_id:       "42",
        partner_order_time:     Time.now
    }
  end

  let(:shipping_addr_params) do
    {
        first_name:   "Testfirstname",
        last_name:    "Fong",
        street1:      "Listia Inc, 200 Blossom Ln",
        street2:      "street2 test",
        city:         "Mountain View",
        state:        "CA",
        zipcode:      "94043",
        country:      "USA",
        phone:        "606-478-0850"
    }
  end

  let(:required_attrs) do
    [:billing_record_id, :first_name, :street1, :city, :state, :zipcode, :country, :phone]
  end

  let(:valid_order_params) { basic_order_params.merge(shipping_addr_params)}

  context "create order" do
    let(:order) { WalmartOpen::Order.new(valid_order_params) }

    context ".new" do
      it "sets value correctly" do
        expect(order.billing_record_id).to eql(valid_order_params[:billing_record_id])
        expect(order.partner_order_time).to eq(valid_order_params[:partner_order_time])
        expect(order.partner_order_id).to eq(valid_order_params[:partner_order_id])

        expect(order.shipping_address).to be_valid
        expect(order.shipping_address.first_name).to eql(valid_order_params[:first_name])
        expect(order.shipping_address.last_name).to eql(valid_order_params[:last_name])
        expect(order.shipping_address.phone).to eql(valid_order_params[:phone])

        expect(order.items).to be_empty
      end

      it "accepts string keys" do
        stringified_valid_attrs = valid_order_params.each_with_object({}) do |pair, obj|
          obj[pair.first.to_s] = pair.last
        end
        order = WalmartOpen::Order.new(stringified_valid_attrs)

        expect(order.billing_record_id).to eql(valid_order_params[:billing_record_id])
        expect(order.partner_order_time).to eq(valid_order_params[:partner_order_time])
        expect(order.partner_order_id).to eq(valid_order_params[:partner_order_id])

        expect(order.shipping_address).to be_valid
        expect(order.shipping_address.first_name).to eql(valid_order_params[:first_name])
        expect(order.shipping_address.last_name).to eql(valid_order_params[:last_name])
        expect(order.shipping_address.phone).to eql(valid_order_params[:phone])

        expect(order.items).to be_empty
      end
    end

    context "#add_item" do
      it "adds item object" do
        item = double
        order.add_item(item)
        expect(order.items).not_to be_empty
      end

      it "adds item by id" do
        order.add_item(1)
        expect(order.items).not_to be_empty
      end
    end
  end

  context "#valid?" do
    context "when required order params are present" do
      before do
        valid_order_params.delete(:last_name)
        valid_order_params.delete("street2")
        @order = WalmartOpen::Order.new(valid_order_params)
        @order.add_item(1)
      end

      it "returns true" do
        expect(@order).to be_valid
      end
    end

    context "when required order params are not present" do
      shared_examples_for "missing required key" do |optional_key|
        before do
          valid_order_params.delete(optional_key) if optional_key
        end

        it "returns false" do
          order = WalmartOpen::Order.new(valid_order_params)
          order.add_item(item_id) if item_id

          expect(order).not_to be_valid
        end
      end

      context "when order item present" do
        let(:item_id) { 1 }
        it_behaves_like "missing required key", :billing_record_id
        it_behaves_like "missing required key", :first_name
        it_behaves_like "missing required key", :street1
        it_behaves_like "missing required key", :city
        it_behaves_like "missing required key", :state
        it_behaves_like "missing required key", :zipcode
        it_behaves_like "missing required key", :country
        it_behaves_like "missing required key", :phone
      end

      context "when order item not present" do
        let(:item_id) {nil}
        it_behaves_like "missing required key", nil
      end
    end
  end
end
