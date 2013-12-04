require "spec_helper"
require "walmart_open/order_results"

describe WalmartOpen::OrderResults do
  context "#initialize" do
    it "sets value correctly with one order" do
      attrs = {
        "response" => {
          "orderId" =>"2677921715556",
          "partnerOrderId"  =>"43",
          "items"           =>  {
              "item" => {
                "itemId"=>"10371356",
                "quantity"=>"1",
                "itemPrice"=>"22.97"
            }
          },
          "total"     =>  "29.95",
          "itemTotal" =>  "22.97",
          "shipping"  =>"4.97",
          "salesTax"  =>"2.01",
          "surcharge" =>"0.00"
        }
      }
      res = WalmartOpen::OrderResults.new(attrs)

      expect(res.order_id).to eq(attrs["response"]["orderId"])
      expect(res.partner_order_id).to eq(attrs["response"]["partnerOrderId"])
      expect(res.total).to eq(attrs["response"]["itemTotal"])
      expect(res.shipping).to eq(attrs["response"]["shipping"])
      expect(res.sales_tax).to eq(attrs["response"]["salesTax"])
      expect(res.surcharge).to eq(attrs["response"]["surcharge"])
      expect(res.raw_attributes).to eq(attrs)
      expect(res.items.count).to eq(1)
      expect(res.error?).to eq(false)
    end

    it "sets value correctly with multiple orders" do
      attrs = {
        "response"  =>  {
          "orderId" =>  "2677922016720",
          "partnerOrderId"  =>  "44",
          "items" =>  {
            "item"  =>  [
                {
                  "itemId"  =>  "20658394",
                  "quantity"  =>  "1",
                  "itemPrice" =>"12.99"
                },
                {
                  "itemId"    =>  "10371356",
                  "quantity"  =>  "1",
                  "itemPrice" =>  "22.97"
                }
              ]
            },
            "total" =>  "39.11",
            "itemTotal" =>  "35.96",
            "shipping"  =>  "0",
            "salesTax"  =>  "3.15",
            "surcharge" =>  "0.00"
        }
      }
      res = WalmartOpen::OrderResults.new(attrs)

      expect(res.order_id).to eq(attrs["response"]["orderId"])
      expect(res.partner_order_id).to eq(attrs["response"]["partnerOrderId"])
      expect(res.total).to eq(attrs["response"]["itemTotal"])
      expect(res.shipping).to eq(attrs["response"]["shipping"])
      expect(res.sales_tax).to eq(attrs["response"]["salesTax"])
      expect(res.surcharge).to eq(attrs["response"]["surcharge"])
      expect(res.raw_attributes).to eq(attrs)
      expect(res.items.count).to eq(2)
      expect(res.error?).to eq(false)
    end
  end
end
