# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'walmart_open/version'

Gem::Specification.new do |spec|
  spec.name          = "walmart_open"
  spec.version       = WalmartOpen::VERSION
  spec.authors       = ["Ngan Pham"]
  spec.email         = ["ngan@listia.com"]
  spec.description   = %q{Ruby implementation for Walmart Open API.}
  spec.summary       = %q{Ruby implementation for Walmart Open API}
  spec.homepage      = "https://github.com/listia/walmart_open"
  spec.license       = "MIT"

  spec.files         = Dir["{lib,spec}/**/*"].select { |f| File.file?(f) } +
                         %w(LICENSE.txt Rakefile README.md)
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.10"
  spec.add_dependency "builder", ">= 3.0.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0.0.beta1"
  spec.add_development_dependency "debugger", "~> 1.6"
end
