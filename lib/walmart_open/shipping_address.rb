module WalmartOpen
  class ShippingAddress
    ATTRIBUTES = [
        :street1,
        :street2,
        :city,
        :state,
        :zipcode,
        :country
    ]
    attr_reader *ATTRIBUTES

    def initialize(params)
      params = params.each_with_object({}) do |pair, obj|
        obj[pair.first.to_sym] = pair.last
      end

      set_attributes(params)
    end

    def valid?
      !!(street1 && city && state && zipcode && country)
    end

    private

    def set_attributes(attrs)
      ATTRIBUTES.each do |attr|
        next unless attrs.include?(attr)

        instance_variable_set("@#{attr}", attrs[attr])
      end
    end
  end
end
