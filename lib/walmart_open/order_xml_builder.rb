require "builder"

module WalmartOpen
  class OrderXMLBuilder
    attr_reader :order

    def initialize(order)
      @order = order
    end

    def build
      xml = Builder::XmlMarkup.new
      xml.instruct!(:xml, version: "1.0", encoding: "UTF-8")
      xml.order do |xml|
        payment(xml)
        shipping_address(xml)
        xml.partnerOrderId(order.partner_order_id)
        xml.partnerOrderTime(order.partner_order_time.strftime( "%H:%M:%S"))

        xml.items do |xml|
          order.items.each do |order_item|
            item(xml, order_item)
          end
        end

        xml.target!
      end

    end

    private

    def shipping_address(xml)
      xml.shippingAddress do |xml|
        xml.firstName(order.first_name)
        xml.lastName(order.last_name)
        xml.street1(order.shipping_address.street1)
        xml.street2(order.shipping_address.street2) if order.shipping_address.street2
        xml.city(order.shipping_address.city)
        xml.state(order.shipping_address.state)
        xml.zip(order.shipping_address.zipcode)
        xml.country(order.shipping_address.country)
        xml.phone(order.phone) if order.phone
      end
    end

    def payment(xml)
      xml.payment do |xml|
        xml.billingRecordId(order.billing_id)
      end
    end

    def item(xml, order_item)
      xml.item do |xml|
        xml.itemId(order_item.item_id)
        xml.quantity(order_item.quantity)
        xml.itemPrice(order_item.item_price)
        xml.shippingPrice(order_item.shipping_price)
      end
    end
  end
end
