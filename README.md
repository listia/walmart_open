# Walmart Open

[Walmart Open](https://developer.walmartlabs.com) is Walmart's official products search and ordering API. There are actually two distinct API endpoints: one for product search and lookup and one for ordering.

## Products API

To use the Products API, you must register for a Walmart Open account and obtain an API key. You can also API calls from their [interacive API tool](https://developer.walmartlabs.com/io-docs).  For documentation can be found here: https://developer.walmartlabs.com/docs.

## Commerce API

As of right now, the Commerce API is [only available to select partners](https://developer.walmartlabs.com/forum/read/162059).  Once you've established a relationship with them, you will need the following to access the Commerce API:
- API Key
- API Secret
- Generated Private/Public Key for message signing. You will need to give them your public key before proceeding.
- A billing record id; Provided to you by Walmart when you give them your public key.
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
  config.commerce_calls_per_second = 1

  # Set this to true for development mode.
  # This mainly applies to the Commerce API; orders will not actually be placed.
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
#=> Item
# when success: example of item
# item.error? == false
# item.id = "15076191"
# item.name = "Apple iPod Touch 4th Generation 32GB with Bonus Accessory Kit"
# item.price = "189.0"
# item.upc = nil
# item.category_node = "3944_96469_164001"
# item.short_description = "The world's most popular portable gaming device ... "
# item.long_description = "&lt;br&gt;&lt;b&gt;Apple iPod touch 32GB (4th Gen) ..."
# item.brand = nil
# item.shipping_rate = 0.0
# item.size = nil
# item.color = "Black"
# item.model_number = ?
# item.url =  "http://www.walmart.com/ip/Apple-iPod-Touch-8GB-32GB-and-64GB-newest-model/15076191"
# item.raw_attributes = {"itemId" => 15076191, .....}

# when fail: example of item
# item.error? == true
# item.error[:code] = 4002
# item.error[:message] = "Invalid itemId"
# item.raw_attributes = {"errors"=>[{"code"=>4002, "message"=>"Invalid itemId"}]}

# Taxonomy
taxonomies = client.taxonomy
#=> Array
# when success, example of one of taxonomies
# taxonomies.categories = {"id"=>"5438", "name"=>"Apparel", "path"=>"Apparel", "children"=>[{"id"=>"5438_426265",
  "name"=>"Accessories", "path"=>"Apparel/Accessories", "children"=>[{"id"=>"5438_426265_1043621",
  "name"=>"Bandanas", "path"=>"Apparel/Accessories/Bandanas"}, ...]]}
```

### Making Commerce API Calls
```ruby
# Placing an Order
order = WalmartOpen::Order.new({billing_id: 1, first_name: "James",
                               last_name: "Fong", partner_order_id: "38",
                               partner_order_time: "16:15:47"})
# required fields:
# billing_id: long, first_name: string
# optional fields:
# last_name: string
# partner_order_time: string in format of HH:MM:SS, default to Time.now
# partner_order_id: string, default to "Order-#{HASH_OF_RAND_AND_ORDER_TIME}"

order.add_shipping_address({street1: "200 Blossom Ln", street2: "100 Flynn Avenue", city: "Mountain View", state: "CA", zipcode: "94043", country: "USA"})
# required:
# street1: string, city: string, state: string, zipcode: string, country: string
# optional:
# street2: string

# add_item method 1, add_item(item_id, item_price, shipping_price = nil, quantity = 1)
order.add_item(10371356, 5, 22.94)
order.add_item(25174174, 214.99)

# add_item method 2, add_item(item, quantity = 1)
order.add_item(client.lookup(10371356))
order.add_item(client.lookup(25174174))

# order.valid? == true

res = client.order(order)
#=> OrderResults
# when order succeeds, we see res as example below
# res.error? = true
# res.order_id = "2677911409503"
# res.partner_order_id = "13"
# res.items = [ ordered_item, ...]
# res.total =  "237.96"  # sum of ordered_item.price for all ordered_items
# res.sales_tax = "20.82"
# res.surcharge = "0.0"
# res.raw_attributes = {"response"=>{"orderId"=>"2677914395453", "partnerOrderId"=>"41", "items"=>{"item"=>{"itemId"=>"10371356", "quantity"=>"1", "itemPrice"=>"22.97"}}, "total"=>"29.95", "itemTotal"=>"22.97", "shipping"=>"4.97", "salesTax"=>"2.01", "surcharge"=>"0.00"}}

# Note that order_item have class OrderedItem. As an example
# ordered_item.id = 25174174
# ordered_item.quantity = 1
# ordered_item.price = 214.99
# ordered_item.raw_attributes = {"itemId"=>"25174174", "quantity"=>"1", "itemPrice"=>"214.99"}

# when order fails, we see res as below
# res.error? == true
# res.error = {:code=>"10001", :message=>"Invalid xml"}
# res.error[:code] = "10001"
# res.error[:message] = "Invalid xml"
# res.raw_attributes = {"errors"=>{"error"=>{"code"=>"10001", "message"=>"Invalid xml"}}}
```

### Authentication failure
In the case of authentication failure during an API call, a
WalmartOpen::AuthenticationError exception will be raised

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
