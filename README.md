# Walmart Open

[Walmart Open](https://developer.walmartlabs.com) is Walmart's official products search API.

## Products API

To use the Products API, you must register for a Walmart Open account and obtain an API key. You can also make API calls from their [interacive API tool](https://developer.walmartlabs.com/io-docs).  For documentation can be found here: https://developer.walmartlabs.com/docs.

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

  # Set this to true for development mode.
  config.debug = true
end
```

### Making Product API Calls
```ruby
# Search
res = client.search("ipod")
#=> SearchResults
# example of res
# res.query = "ipod"
# res.total = 53259
# res.start = 1
# res.page = ?
# res.items = [ Item_1, Item_2 ....]

# Lookup (by item id)
item = client.lookup(15076191)
#=> item is of class WalmartOpen::Item, see WalmartOpen::Item section for detail
# When item not found, an error of class WalmartOpen::ItemNotFoundError is thrown,
  eg: {"errors"=>[{"code"=>4002, "message"=>"Invalid itemId"}]}
  When walmart api is down, an error of class WalmartOpen::ServerError is thrown,
  eg: {"errors"=>[{"code"=>504, "message"=>"Gateway Timeout"}]}

# Taxonomy
taxonomies = client.taxonomy
#=> Array
# when success, example of one of taxonomies
# taxonomies.categories = {"id"=>"5438", "name"=>"Apparel", "path"=>"Apparel", "children"=>[{"id"=>"5438_426265",
  "name"=>"Accessories", "path"=>"Apparel/Accessories", "children"=>[{"id"=>"5438_426265_1043621",
  "name"=>"Bandanas", "path"=>"Apparel/Accessories/Bandanas"}, ...]]}

# Search special feeds (by feed type, category id)
# Feed type can be :preorder, :bestsellers, :rollback, :clearance, :specialbuy
# For :preorder case, you do not need to pass param category_id
items = client.feed(:bestsellers, category_id)
#=> Array
# when success: items is an array of WalmartOpen::Item items
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
