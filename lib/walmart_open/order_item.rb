module WalmartOpen
  class OrderItem

    attr_accessor :item_id, :quantity, :item_price, :shipping_price

    def initialize(item_id, item_price, shipping_price = 0, quantity = 1)
      @item_id = item_id
      @quantity = quantity
      @item_price = item_price
      @shipping_price = shipping_price
    end

    def valid?
      !!(item_id && quantity && item_price && shipping_price)
    end
  end
end
