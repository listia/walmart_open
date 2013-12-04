require "spec_helper"
require "walmart_open/config"
require "walmart_open/client"
require "walmart_open/errors"

describe WalmartOpen::Config do
  context "#initialize" do
    it "sets default configs" do
      config = WalmartOpen::Config.new

      expect(config.debug).to be(false)
      expect(config.product_domain).to eq("walmartlabs.api.mashery.com")
      expect(config.product_version).to eq("v1")
      expect(config.commerce_domain).to eq("api.walmartlabs.com")
      expect(config.commerce_version).to eq("v1")
      expect(config.product_calls_per_second).to be(5)
      expect(config.commerce_calls_per_second).to be(2)
    end

    it "allows setting configs" do
      config = WalmartOpen::Config.new({debug: true, product_domain: "test",
                commerce_domain: "test", product_version: "test",
                commerce_version: "test", product_calls_per_second: 1,
                commerce_calls_per_second: 1})

      expect(config.debug).to be(true)
      expect(config.product_domain).to eq("test")
      expect(config.product_version).to eq("test")
      expect(config.commerce_domain).to eq("test")
      expect(config.commerce_version).to eq("test")
      expect(config.product_calls_per_second).to be(1)
      expect(config.commerce_calls_per_second).to be(1)
    end
  end
end
