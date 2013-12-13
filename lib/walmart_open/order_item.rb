module WalmartOpen
  class OrderItem

    attr_accessor :item_id, :quantity, :item_price, :shipping_price

    def initialize(item_id, quantity = 1, item_price = nil, shipping_price = nil)
      @item_id = item_id
      @quantity = quantity
      @item_price = item_price
      @shipping_price = shipping_price
    end

    def valid?
      !!(item_id && quantity)
    end
  end
end
