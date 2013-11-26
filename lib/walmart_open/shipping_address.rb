module WalmartOpen
  class ShippingAddress
    API_ATTRIBUTES_MAPPING = {
        :street1 => "street1",
        :street2 => "street2",
        :city => "city",
        :state => "state",
        :zipcode => "zipcode",
        :country => "country",
    }

    API_ATTRIBUTES_MAPPING.each_value do |attr_name|
      attr_reader attr_name
    end

    attr_reader :raw_attributes

    def initialize(params)
      @raw_attributes = params
      extract_known_attributes
    end

    def valid?
      !((street1 && city && state && zipcode && country).nil?)
    end

    private
    def extract_known_attributes
      API_ATTRIBUTES_MAPPING.each do |api_attr, attr|
        next unless raw_attributes.has_key?(api_attr)

        instance_variable_set("@#{attr}", raw_attributes[api_attr])
      end
    end
  end
end
