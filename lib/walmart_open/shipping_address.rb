module WalmartOpen
  class ShippingAddress
    ATTRIBUTES = [
        :first_name,
        :last_name,
        :street1,
        :street2,
        :city,
        :state,
        :zipcode,
        :country,
        :phone
    ]
    attr_reader *ATTRIBUTES

    def initialize(params)
      params = params.each_with_object({}) do |pair, obj|
        obj[pair.first.to_sym] = pair.last
      end

      set_attributes(params)
    end

    def valid?
      !!(first_name && street1 && city && state && zipcode && country && phone)
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
