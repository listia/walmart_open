require "builder"

module WalmartOpen
  class OrderXSDBuilder
    attr_reader :order_information

    def initialize(order_information)
      @order_information = order_information
    end

    def build
      xml = Builder::XmlMarkup.new
      xml.instruct!(:xml, version: "1.0", encoding: "UTF-8")
      xml.order do |xml|
        payment(xml)
        shipping_address(xml)

        xml.partnerOrderId("??")
        xml.partnerOrderTime("??")

        xml.items do |xml|
          item(xml)
        end
        xml.target!
      end

    end

    private

    def shipping_address(xml)
      xml.shippingAddress do |xml|
        xml.firstName(order_information[:first_name])
        xml.lastName(order_information[:last_name])
        xml.street1(order_information[:street_address])
        xml.city(order_information[:city])
        xml.state(order_information[:state])
        xml.zip(order_information[:zipcode])
        xml.country(order_information[:country])
        xml.phone(order_information[:phone])
      end
    end

    def payment(xml)
      xml.payment do |xml|
        xml.billingRecordId(order_information[:billing_id])
      end
    end

    def item(xml)
      xml.item do |xml|
        xml.itemId(order_information[:item_id])
        xml.quantity(1)
        xml.itemPrice("??")
        xml.shippingPrice("??")
      end
    end
  end
end
