require "spec_helper"
require "walmart_open/stock_string"

describe WalmartOpen::StockString do
  shared_examples "query method" do |method_name, humanized|
    it "returns true when #{humanized}" do
      expect(stock.public_send(method_name)).to eq(true)
      expect(stock.downcase.public_send(method_name)).to eq(true)
      expect(stock.upcase.public_send(method_name)).to eq(true)
    end

    it "returns true when something else" do
      bad_stock = WalmartOpen::StockString.new("Something else")
      expect(bad_stock.public_send(method_name)).to eq(false)
    end
  end

  context "#available?" do
    let(:stock) { WalmartOpen::StockString.new("Available") }

    include_examples "query method", :available?, "available"
  end

  context "#limited?" do
    let(:stock) { WalmartOpen::StockString.new("Limited Supply") }

    include_examples "query method", :limited?, "limited"
  end

  context "#few?" do
    let(:stock) { WalmartOpen::StockString.new("Last few items") }

    include_examples "query method", :few?, "few"
  end

  context "#not_available?" do
    let(:stock) { WalmartOpen::StockString.new("Not available") }

    include_examples "query method", :not_available?, "not available"
  end
end
