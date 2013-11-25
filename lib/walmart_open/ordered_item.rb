module WalmartOpen
  class OrderedItem
    API_ATTRIBUTES_MAPPING = {
      "itemId" => "id",
      "quantity" => "quantity",
      "itemPrice" => "price"
    }

    API_ATTRIBUTES_MAPPING.each_value do |attr_name|
      attr_reader attr_name
    end

    attr_reader :raw_attributes

    def initialize(attrs)
      @raw_attributes = attrs

      extract_known_attributes
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
