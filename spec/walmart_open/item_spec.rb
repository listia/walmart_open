require "spec_helper"
require "walmart_open/item"

describe WalmartOpen::Item do
  let(:large_image_url) { "http://i.walmartimages.com/i/p/00/80/14/18/71/0080141871195_Color_Burgundy_SW_500X500.jpg" }
  let(:thumbnail_image) { "http://i.walmartimages.com/i/p/00/80/14/18/71/0080141871195_Color_Burgundy_SW_100X100.jpg" }
  let(:medium_image) { "http://i.walmartimages.com/i/p/00/80/14/18/71/0080141871195_Color_Burgundy_SW_180X180.jpg" }
  let(:item_attrs) do
    {
      "itemId"                  =>  10371356,
      "parentItemId"            =>  10371356,
      "name"                    =>  "Microplush Blanket",
      "salePrice"               =>  22.97,
      "upc"                     =>  "801418711959",
      "categoryPath"            =>  "Home/Bedding/Blankets & Throws",
      "shortDescription"        =>  "Cuddle up in bed, on the couch, or even on a sandy beach with this super-soft and thick microfiber blanket. It's luxuriously crafted to provide sumptuous warmth and comfort, even in the coldest environment. Constructed from 100% microfiber, the blanket yarns feel plush and cozy against your skin. This lavish microplush blanket is available in 7 beautiful colors, and can be elegantly matched to any home decor. It works well as an outdoor blanket too &mdash; it's perfect for picnics, long car rides, and trips to the ballpark. Plus, this microplush blanket is easy to take care of without hassle, and saves valuable energy over electric blankets. Now you can bundle up and stay warm anywhere, indoors or out. &lt;p&gt;Soft microplush blanket is available in Twin, Full, Queen and King Sizes.&lt;/p&gt;", "longDescription"=>"&lt;p&gt;&lt;b&gt;Microplush Blanket, 7 Colors:&lt;/b&gt;&lt;/p&gt;&lt;ul&gt;&lt;li&gt;Super-soft, thick and plush&lt;/li&gt;&lt;li&gt;100% microfiber blanket yarns are soft and plush to the touch&lt;/li&gt;&lt;li&gt;Microplush blanket is suitable for all-year use, and can be used indoors or outdoors without hassle&lt;/li&gt;&lt;li&gt;Luxurious microplush blanket is easy to clean  just machine wash and tumble dry&lt;/li&gt;&lt;li&gt;Twin: 90&quot; x 66&quot;&lt;/li&gt;&lt;li&gt;Full: 90&quot; x 80&quot;&lt;/li&gt;&lt;li&gt;Queen: 90&quot; x 90&quot;&lt;/li&gt;&lt;li&gt;King: 90&quot; x 102&quot;&lt;/li&gt;&lt;/ul&gt;",
      "brandName"               =>  "Sun Yin",
      "thumbnailImage"          =>  "http://i.walmartimages.com/i/p/00/80/14/18/71/0080141871195_Color_Burgundy_SW_100X100.jpg",
      "mediumImage"             =>  "http://i.walmartimages.com/i/p/00/80/14/18/71/0080141871195_Color_Burgundy_SW_180X180.jpg",
      "largeImage"              =>  "http://i.walmartimages.com/i/p/00/80/14/18/71/0080141871195_Color_Burgundy_SW_500X500.jpg",
      "productTrackingUrl"      =>  "http://linksynergy.walmart.com/fs-bin/click?id=|LSNID|&offerid=223073.7200&type=14&catid=8&subid=0&hid=7200&tmpid=1081&RD_PARM1=http%253A%252F%252Fwww.walmart.com%252Fip%252FMicroplush-Blanket%252F10371356%253Faffilsrc%253Dapi",
      "ninetySevenCentShipping" =>  false,
      "standardShipRate"        =>  4.97,
      "twoThreeDayShippingRate" =>  10.97,
      "overnightShippingRate"   =>  14.97,
      "size"                    =>  "Twin",
      "color"                   =>  "Burgundy",
      "marketplace"             =>  false,
      "shipToStore"             =>  true,
      "freeShipToStore"         =>  true,
      "modelNumber"             =>  "BKT051166T",
      "productUrl"              =>  "http://www.walmart.com/ip/Microplush-Blanket/10371356",
      "customerRating"          =>  "4.446",
      "numReviews"              =>  621,
      "customerRatingImage"     =>  "http://i2.walmartimages.com/i/CustRating/4_4.gif",
      "categoryNode"            =>  "4044_539103_4756",
      "rollBack"                =>  false,
      "bundle"                  =>  false,
      "clearance"               =>  false,
      "preOrder"                =>  false,
      "stock"                   =>  "Available",
      "availableOnline"         =>  true
    }
  end

  context ".new" do
    it "sets attributes" do
      item = WalmartOpen::Item.new(item_attrs)
      WalmartOpen::Item::API_ATTRIBUTES_MAPPING.each do |key, value|
        expect(item.send(value)).to eq(item_attrs[key])
      end
      expect(item.raw_attributes).to eq(item_attrs)
    end
  end
end
