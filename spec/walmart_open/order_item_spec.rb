require "spec_helper"
require "walmart_open/order_item"

describe WalmartOpen::OrderItem do
  context ".new" do
    it "sets value correctly" do
      item_id = 10371356
      item_price = 1.23
      order_item = WalmartOpen::OrderItem.new(item_id, item_price)

      expect(order_item.item_id).to eq(item_id)
      expect(order_item.item_price).to eq(item_price)
      expect(order_item.shipping_price).to eq(0)
      expect(order_item.quantity).to eq(1)
      expect(order_item).to be_valid
    end
  end
end
