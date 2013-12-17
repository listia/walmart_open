module WalmartOpen
  class ShippingAddress
    REQUIRED_ATTRIBUTES = [
      :first_name,
      :street1,
      :city,
      :state,
      :zipcode,
      :country,
      :phone
    ]

    OPTIONAL_ATTRIBUTES = [
      :last_name,
      :street2,
    ]

    ATTRIBUTES = REQUIRED_ATTRIBUTES + OPTIONAL_ATTRIBUTES

    attr_reader *ATTRIBUTES

    def initialize(params)
      params = params.each_with_object({}) do |pair, obj|
        obj[pair.first.to_sym] = pair.last
      end

      set_attributes(params)
    end

    def valid?
      REQUIRED_ATTRIBUTES.map do |attr|
        public_send(attr).to_s.empty?
      end.none?
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
