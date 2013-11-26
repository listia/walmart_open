require "walmart_open/ordered_item"

module WalmartOpen
  class OrderResults
    attr_reader :error, :order_id, :partner_order_id, :items, :total, :shipping, :sales_tax, :surcharge, :raw_attributes

    def initialize(attrs)
      @error = nil
      @raw_attributes = attrs

      if attrs["errors"] && attrs["errors"]["error"]
        @error = {code: attrs["errors"]["error"]["code"], message: attrs["errors"]["error"]["message"]}
      else
        response = attrs["response"]
        @order_id = response["orderId"]
        @partner_order_id = response["partnerOrderId"]
        @total = response["itemTotal"]
        @shipping = response["shipping"]
        @sales_tax = response["salesTax"]
        @surcharge = response["surcharge"]

        @items = []
        if response["items"] && response["items"]["item"]
          if response["items"]["item"].is_a?(Array)
            items = response["items"]["item"]
          else
            items = [response["items"]["item"]]
          end
          items.each do | item |
            @items << OrderedItem.new(item)
          end
        end
      end
    end

    def error?
      !@error.nil?
    end
  end

end
