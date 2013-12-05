require "spec_helper"
require "walmart_open/requests/search"
require "walmart_open/client"
require "walmart_open/errors"

describe WalmartOpen::Requests::Search do
  context "#submit" do
    let(:client) { WalmartOpen::Client.new }
    let(:success_response) { double(success?: true) }
    let(:fail_response) { double(success?: false) }
    let(:search_req) { WalmartOpen::Requests::Search.new("ipod") }
    let(:search_response) do
      {
        "query" => "ipod",
        "sort" => "relevance",
        "format" => "json",
        "responseGroup" => "base",
        "totalResults" => 38666,
        "start" => 1,
        "numItems" => 10,
        "items" => [
        {
            "itemId" => 21967115,
            "parentItemId" => 21967115,
            "name" => "Apple iPod Touch 5th Generation (Choose Your Color in 32GB or 64GB) with Bonus Accessory Kit",
            "salePrice" => 279.0,
            "categoryPath" => "Electronics/iPods & MP3 Players/Apple iPods",
            "shortDescription" => "With an ultrathin design, a 4-inch Retina display, a 5-megapixel iSight camera on the 32GB and 64GB models, iTunes and the App Store, Siri, iMessage, FaceTime, Game Center and more it's the most fun iPod touch ever.",
            "longDescription"=>"iPod touch features a 6-millimetre ultrathin design and a brilliant 4-inch Retina display. The 5-megapixel iSight camera on the 32GB and 64GB models lets you take stunning photos, even in panorama or record 1080p video. Discover music, movies and more from the iTunes Store or browse apps and games from the App Store. And with iOS 6 the world's most advanced mobile operating system you get Siri, iMessage, Facebook integration, FaceTime, Game Center and more.&lt;p&gt;Key Features&lt;/p&gt;&lt;p&gt;&lt;/p&gt;&lt;ul class=&quot;noindent&quot;&gt;&lt;li&gt;Ultrathin design available in five gorgeous colors&lt;/li&gt;&lt;li&gt;4-inch Retina display&lt;/li&gt;&lt;li&gt;Apple A5 chip&lt;/li&gt;&lt;li&gt;5-megapixel iSight camera with 1080p HD video recording&lt;/li&gt;&lt;li&gt;FaceTime HD camera with 1.2-megapixel photos and 720p HD video recording&lt;/li&gt;&lt;li&gt;iOS 6 with features like Siri, Passbook and Facebook integration&lt;/li&gt;&lt;li&gt;iTunes Store with millions of songs and thousands of movies and TV shows&lt;/li&gt;&lt;li&gt;App Store with more than 900,000 apps, including over 100,000 games&lt;/li&gt;&lt;li&gt;Game Center with millions of gamers&lt;/li&gt;&lt;li&gt;Free text messaging over Wi-Fi with iMessage&lt;/li&gt;&lt;li&gt;Rich HTML email and Safari web browser&lt;/li&gt;&lt;li&gt;AirPlay and AirPlay Mirroring&lt;/li&gt;&lt;li&gt;40 hours of music playback, 8 hours of video playback&lt;/li&gt;&lt;li&gt;iPod touch loop included&lt;/li&gt;&lt;/ul&gt;", "thumbnailImage"=>"http://i.walmartimages.com/i/p/11/13/01/55/15/1113015515798_100X100.jpg", "productTrackingUrl"=>"http://linksynergy.walmart.com/fs-bin/click?id=|LSNID|&offerid=223073.7200&type=14&catid=8&subid=0&hid=7200&tmpid=1081&RD_PARM1=http%253A%252F%252Fwww.walmart.com%252Fip%252FApple-iPod-Touch-5th-Generation-Choose-Your-Color-in-32GB-or-64GB-with-Bonus-Accessory-Kit%252F21967115%253Faffilsrc%253Dapi", "standardShipRate"=>0.0, "marketplace"=>false, "productUrl"=>"http://www.walmart.com/ip/Apple-iPod-Touch-5th-Generation-Choose-Your-Color-in-32GB-or-64GB-with-Bonus-Accessory-Kit/21967115",
            "categoryNode"=>"3944_96469_1057284",
            "bundle"=>true,
            "availableOnline"=>true
        },
        {
            "itemId" => 21967113,
            "parentItemId" => 21967113,
            "name" => "Apple iPod Nano 16GB (Choose Your Color) with Bonus Accessory Kit",
            "salePrice" => 139.0,
            "categoryPath" => "Electronics/iPods & MP3 Players/Apple iPods",
            "shortDescription" => "The redesigned, ultraportable iPod nano now has a larger, 2.5&quot; ",
            "longDescription" => "&lt;br&gt;&lt;b&gt;Key Features:&lt;/b&gt;&lt;ul&gt;&lt;li&gt;2.5&quot; ",
            "thumbnailImage" => "http://i.walmartimages.com/i/p/11/13/01/55/15/1113015515796_100X100.jpg",
            "productTrackingUrl" => "http://linksynergy.walmart.com/fs-bin/click?id=|LSNID|&offerid=223073.7200&type=14&catid=8&subid=0&hid=7200&tmpid=1081&RD_PARM1=http%253A%252F%252Fwww.walmart.com%252Fip%252FApple-iPod-Nano-16GB-Choose-Your-Color-with-Bonus-Accessory-Kit%252F21967113%253Faffilsrc%253Dapi",
            "standardShipRate" => 0.0,
            "marketplace" => false,
            "productUrl" => "http://www.walmart.com/ip/Apple-iPod-Nano-16GB-Choose-Your-Color-with-Bonus-Accessory-Kit/21967113",
            "categoryNode" => "3944_96469_1057284",
            "bundle" => true,
            "availableOnline" => true
        }],
      }
    end
    context "get success response" do
      before do
        expect(HTTParty).to receive(:get).and_return(success_response)
        allow(success_response).to receive(:parsed_response).and_return(search_response)
      end

      it "return response" do
        search_results = search_req.submit(client)

        expect(search_results.query).to eq(search_response["query"])
        expect(search_results.total).to eq(search_response["totalResults"])
        expect(search_results.start).to eq(search_response["start"])
        expect(search_results.items.count).to be(search_response["items"].count)
      end
    end

    context "get fail response" do
      before do
        allow(fail_response).to receive(:parsed_response).and_return({
          "errors" => [{
                           "code" => 403,
                           "message" => "Account Inactive"
                       }]
        })
      end
      it "raises authentication error" do
        expect {
          search_req.submit(client)
        }.to raise_error(WalmartOpen::AuthenticationError)
      end
    end
  end
end

