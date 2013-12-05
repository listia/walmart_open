require "spec_helper"
require "walmart_open/search_results"

describe WalmartOpen::SearchResults do
  context "#initialize" do
    let(:search_result) do
      {
        "query" => "ipod",
        "sort" => "relevance",
        "format" => "json",
        "responseGroup" => "base",
        "totalResults" => 38666,
        "start" => 1,
        "numItems" => 10,
        "items"=>[
          {
            "itemId" => 21967115,
            "parentItemId" => 21967115,
            "name" => "Apple iPod Touch 5th Generation (Choose Your Color in 32GB or 64GB) with Bonus Accessory Kit",
            "salePrice" => 279.0,
            "categoryPath" => "Electronics/iPods & MP3 Players/Apple iPods",
            "shortDescription" => "With an ultrathin design, a 4-inch Retina display.",
            "longDescription" => "iPod touch features a 6-millimetre ultrathin design and a brilliant 4-inch Retina display.",
            "thumbnailImage" => "http://i.walmartimages.com/i/p/11/13/01/55/15/1113015515798_100X100.jpg", "productTrackingUrl"=>"http://linksynergy.walmart.com/fs-bin/click?id=|LSNID|&offerid=223073.7200&type=14&catid=8&subid=0&hid=7200&tmpid=1081&RD_PARM1=http%253A%252F%252Fwww.walmart.com%252Fip%252FApple-iPod-Touch-5th-Generation-Choose-Your-Color-in-32GB-or-64GB-with-Bonus-Accessory-Kit%252F21967115%253Faffilsrc%253Dapi",
            "standardShipRate" => 0.0,
            "marketplace" => false,
            "productUrl" => "http://www.walmart.com/ip/Apple-iPod-Touch-5th-Generation-Choose-Your-Color-in-32GB-or-64GB-with-Bonus-Accessory-Kit/21967115",
            "categoryNode" => "3944_96469_1057284",
            "bundle" => true,
            "availableOnline" => true
          },
          {
            "itemId" => 21967113,
            "parentItemId" => 21967113,
            "name" => "Apple iPod Nano 16GB (Choose Your Color) with Bonus Accessory Kit",
            "salePrice" => 139.0,
            "categoryPath" => "Electronics/iPods & MP3 Players/Apple iPods",
            "shortDescription" =>"The redesigned, ultraportable iPod nano now has a larger, 2.5&quot.",
            "longDescription" => "&lt;br&gt;&lt;b&gt;Key Features:&lt;",
            "customerRating" => "4.789",
            "numReviews" => 375,
            "customerRatingImage" => "http://i2.walmartimages.com/i/CustRating/4_8.gif",
            "categoryNode" => "3944_96469_1057284",
            "bundle" => false,
            "availableOnline" => true
          }
        ]
      }
    end

    it "sets value correctly" do
      search_results = WalmartOpen::SearchResults.new(search_result)

      expect(search_results.query).to eq(search_result["query"])
      expect(search_results.total).to eq(search_result["totalResults"])
      expect(search_results.start).to eq(search_result["start"])
      expect(search_results.items.count).to be(search_result["items"].count)
    end
  end
end
