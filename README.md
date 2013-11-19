# Walmart Open

[Walmart Open](https://developer.walmartlabs.com) is Walmart's official products search and ordering API. There are actually two distinct API endpoints: one for product search and lookup and one for ordering.

## Products API

To use the Products API, you must register for a Walmart Open account and obtain an API key. You can also API calls from their [interacive API tool](https://developer.walmartlabs.com/io-docs).  For documentation can be found here: https://developer.walmartlabs.com/docs.

## Commerce API

As of right now, the Commerce API is [only available to select partners](https://developer.walmartlabs.com/forum/read/162059).  Once you've established a relationship with them, you will need the following to access the Commerce API:
- API Key
- API Secret
- Generated Private/Public Key for message signing. You will need to give them your public key before proceeding.
- A [walmart.com](http://www.walmart.com) account that is connected to your Walmart Open account.

## Installation

Add this line to your application's Gemfile:

    gem 'walmart_open'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install walmart_open

## Usage

### Configuring the Client
```ruby
require "walmart_open"

client = WalmartOpen::Client.new do |config|
  ## Product API
  config.product_api_key = "GggS6aPxDteRCyRxYnqz9bPp"

  # This value defaults to 5.
  config.product_calls_per_second = 4
  
  ## Commerce API
  config.commerce_api_key = "7XQLSmhqTXJHQ5xdGG7ZUh8d"
  config.commerce_api_secret = "Mm5BX4c7QC"
  config.commerce_private_key = File.read("/path/to/your/private/key/file")
  
  # This value defaults to 2.
  commerce_calls_per_second = 1

  # Set this to true for development mode.
  # This mainly applies to the Commerce API; orders will not actually be placed.
  config.debug = true
end
```

### Making Product API Calls
```ruby
# Search
client.search("ipod")
#=> SearchResults

# Lookup (by item id)
client.lookup(43542221)
#=> Item

# Taxonomy
client.taxonomy
#=> Array
```

### Making Commerce API Calls
```ruby
# Placing an Order (by item id)
client.order(43542221)
#=> ???
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
