module WalmartOpen
  class Item
    API_ATTRIBUTES_MAPPING = {
      "itemId" => "id",
      "name" => "name",
      "salePrice" => "price",
      "upc" => "upc",
      "categoryNode" => "category_node",
      "shortDescription" => "short_description",
      "longDescription" => "long_description",
      "branchName" => "brand",
      "standardShipRate" => "shipping_rate",
      "size" => "size",
      "color" => "color",
      "modelNumber" => "model_number",
      "productUrl" => "url"
    }

    API_ATTRIBUTES_MAPPING.each_value do |attr_name|
      attr_reader attr_name
    end

    attr_reader :raw_attributes, :error

    def initialize(attrs)
      @error = nil
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
