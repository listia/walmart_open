require "builder"

module WalmartOpen
  class OrderXSDBuilder
    def build
      schema(Builder::XmlMarkup.new) do |xml|
        documentation(xml)

        define_shipping_address_type(xml)
        define_payment_type(xml)
        define_amount_type(xml)
        define_item_type(xml)
        define_order_type(xml)
        define_response_type(xml)
        define_error_type(xml)
        define_errors_type(xml)

        xml.xsd(:element, name: "order",    type: "order")
        xml.xsd(:element, name: "response", type: "response")
        xml.xsd(:element, name: "errors",   type: "errors")
      end.target!
    end

    private

    def schema(xml, &block)
      xml.xsd(:schema, {
        "xmlns:xsd"    => "http://www.w3.org/2001/XMLSchema",
        "xmlns:jaxb"   => "http://java.sun.com/xml/ns/jaxb",
        "jaxb:version" => "2.1"
      }, &block)
    end

    def documentation(xml)
      xml.xsd(:annotation) do |xml|
        xml.xsd(:documentation, { "xml:lang" => "en" }, "Place order schema for walmart.com\nCopyright 2013 Wal-Mart Stores, Inc.")
      end
    end

    def define_shipping_address_type(xml)
      xml.xsd(:complexType, name: "shippingAddress") do |xml|
        xml.xsd(:sequence) do |xml|
          xml.xsd(:element, name: "firstName", type: "xsd:string", minOccurs: 1)
          xml.xsd(:element, name: "lastName",  type: "xsd:string", minOccurs: 0)
          xml.xsd(:element, name: "street1",   type: "xsd:string")
          xml.xsd(:element, name: "city",      type: "xsd:string")
          xml.xsd(:element, name: "state",     type: "xsd:string")
          xml.xsd(:element, name: "zip",       type: "xsd:string")
          xml.xsd(:element, name: "country",   type: "xsd:string", fixed: "USA")
          xml.xsd(:element, name: "phone",     type: "xsd:string", minOccurs: 0)
        end
      end
    end

    def define_payment_type(xml)
      xml.xsd(:complexType, name: "payment") do |xml|
        xml.xsd(:sequence) do |xml|
          xml.xsd(:element, name: "billingRecordId", type: "xsd:long")
        end
      end
    end

    def define_amount_type(xml)
      xml.xsd(:simpleType, name: "amount") do |xml|
        xml.xsd(:restriction, base: "xsd:decimal") do |xml|
          xml.xsd(:minInclusive, value: 0)
          xml.xsd(:fractionDigits, value: 2)
        end
      end
    end

    def define_item_type(xml)
      xml.xsd(:complexType, name: "item") do |xml|
        xml.xsd(:sequence) do |xml|
          xml.xsd(:element, name: "itemId",   type: "xsd:long")
          xml.xsd(:element, name: "quantity", type: "xsd:int")
          # Price per item
          xml.xsd(:element, name: "itemPrice", type: "amount")
          # Shipping price per item
          xml.xsd(:element, name: "shippingPrice", type: "amount", minOccurs: 0)
        end
      end
    end

    def define_order_type(xml)
      xml.xsd(:complexType, name: "order") do |xml|
        xml.xsd(:all) do |xml|
          xml.xsd(:element, name: "payment",         type: "payment")
          xml.xsd(:element, name: "shippingAddress", type: "shippingAddress")
          xml.xsd(:element, name: "partnerOrderId",  type: "xsd:string")
          # Time when the partner accepted the order on their end (with timezone)
          xml.xsd(:element, name: "partnerOrderTime", type: "xsd:time")
          xml.xsd(:element, name: "items") do |xml|
            xml.xsd(:complexType) do |xml|
              xml.xsd(:sequence) do |xml|
                xml.xsd(:element, name: "item", type: "item", maxOccurs: "unbounded", minOccurs: 1)
              end
            end
          end
        end
      end
    end

    def define_response_type(xml)
      xml.xsd(:complexType, name: "response") do |xml|
        xml.xsd(:all) do |xml|
          xml.xsd(:element, name: "orderId", type: "xsd:string")
          xml.xsd(:element, name: "partnerOrderId", type: "xsd:string")
          xml.xsd(:element, name: "items") do |xml|
            xml.xsd(:complexType) do |xml|
              xml.xsd(:sequence) do |xml|
                xml.xsd(:element, name: "item", type: "item", maxOccurs: "unbounded", minOccurs: 1)
              end
            end
          end
          xml.xsd(:element, name: "total",     type: "amount")
          xml.xsd(:element, name: "itemTotal", type: "amount")
          # These are optional, depending on the order:
          xml.xsd(:element, name: "shipping",    type: "amount", minOccurs: 0)
          xml.xsd(:element, name: "salesTax",    type: "amount", minOccurs: 0)
          xml.xsd(:element, name: "shippingTax", type: "amount", minOccurs: 0)
          xml.xsd(:element, name: "surcharge",   type: "amount", minOccurs: 0)
        end
      end
    end

    def define_error_type(xml)
      xml.xsd(:complexType, name: "error") do |xml|
        xml.xsd(:sequence) do |xml|
          xml.xsd(:element, name: "code", type: "xsd:int")
          xml.xsd(:element, name: "message", type: "xsd:string")
        end
      end
    end

    def define_errors_type(xml)
      xml.xsd(:complexType, name: "errors") do |xml|
        xml.xsd(:sequence) do |xml|
          xml.xsd(:element, name: "error", type: "error", maxOccurs: "unbounded", minOccurs: 1)
        end
      end
    end
  end
end
