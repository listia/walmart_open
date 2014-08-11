module WalmartOpen
  class StockString < String
    METHODS = {
      available:     "Available",
      limited:       "Limited Supply",
      few:           "Last few items",
      not_available: "Not available"
    }

    METHODS.each do |method_name, value|
      define_method("#{method_name}?") do
        self.casecmp(value) == 0
      end
    end
  end
end
