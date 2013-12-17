require "walmart_open/order_item"
require "walmart_open/item"
require "walmart_open/shipping_address"
require "securerandom"

module WalmartOpen
  class Order

    attr_reader :shipping_address, :items
    attr_accessor :billing_record_id, :partner_order_time, :partner_order_id

    def initialize(params)
      params = params.each_with_object({}) do |pair, obj|
        obj[pair.first.to_sym] = pair.last
      end

      @shipping_address = nil
      @items = []
      @billing_record_id = params[:billing_record_id]
      @partner_order_id = params[:partner_order_id] || "Order-#{Digest::SHA1.hexdigest("#{Time.now.to_i}:#{SecureRandom.hex(16)}")[0..19].upcase}"
      @partner_order_time = params[:partner_order_time] || Time.now
      @shipping_address = add_shipping_address(params)
    end

    def add_item(item_or_item_id, quantity = 1, *args)
      if item_or_item_id.is_a?(Item)
        # add_item(item, quantity = 1)
        @items << OrderItem.new(item_or_item_id.id, quantity, item_or_item_id.price, item_or_item_id.shipping_rate)
      else
        # add_item(item_id, quantity = 1, item_price = nil, shipping_price = nil)
        @items <<  OrderItem.new(item_or_item_id, quantity, args[0], args[1])
      end
    end

    def valid?
      base_values_valid? && items_valid? &&
        shipping_address && shipping_address.valid?
    end

    private

    def add_shipping_address(params)
      ShippingAddress.new(params)
    end

    def base_values_valid?
      !!(billing_record_id && partner_order_time && partner_order_id)
    end

    def items_valid?
      items.any? && items.all?(&:valid?)
    end

  end
end
