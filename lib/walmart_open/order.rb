require "walmart_open/order_item"
require "walmart_open/item"
require "walmart_open/shipping_address"

module WalmartOpen
  class Order

    attr_reader :shipping_address
    attr_accessor :billing_id, :first_name, :last_name, :partner_order_time,
                  :partner_order_id, :phone, :items

    def initialize(params)
      @shipping_address = nil
      @items = []
      @billing_id = params[:billing_id]
      @first_name = params[:first_name]
      @last_name = params[:last_name]
      @partner_order_id = params[:partner_order_id] || "Order-#{Digest::SHA1.hexdigest("#{Time.now.to_i}:#{SecureRandom.hex(16)}")[0..19].upcase}"
      @partner_order_time = params[:partner_order_time] || Time.now
    end

    def add_shipping_address(params)
      @shipping_address = ShippingAddress.new(params)
    end

    def add_item(item_or_item_id, *args)
      if item_or_item_id.is_a?(Item)
        # add_item(item, quantity = 1)
        @items << OrderItem.new(item_or_item_id.id, item_or_item_id.price, item_or_item_id.shipping_rate, args[0] || 1)
      else
        # add_item(item_id, item_price, shipping_price = 0, quantity = 1)
        @items <<  OrderItem.new(item_or_item_id, args[0], args[1] || 0, args[2] || 1)
      end
    end

    def valid?
      base_values_valid? && !shipping_address.nil? && shipping_address.valid? && items_valid?
    end

    private

    def base_values_valid?
      billing_id && first_name && partner_order_time && partner_order_id
    end

    def items_valid?
      items.any? && items.all?(&:valid?)
    end

  end
end
