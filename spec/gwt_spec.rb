require "rubygems"

require "fakeweb"
require "gdata"
require "net/https"
require "nokogiri"
require "rspec"
require "spec_helper"
require "test/unit"
require "vcr"

require "lib/gwt/GwtUser"

VCR.config do |c|
  c.cassette_library_dir = "fixtures/cassettes"
  c.stub_with :webmock # or :fakeweb
end

describe "toolkit" do

  context "new GWT account" do
    VCR.use_cassette( "blanconiño" ) do
      u = GwtUser.new( "new_account" )

      use_vcr_cassette "messages_feed"
      it "should have a messages feed" do
        u.messages.css( "title" ).text.should == "Messages"
      end

      it "'s messages feed should be empty" do
        u.messages.css( "entry" ).size.should be == 0
      end

      use_vcr_cassette "sites_feed"
      it "should contain no sites" do
        u.sites.css( "entry" ).size.should be == 0
      end

    end
  end

  context "new GWT account" do
    VCR.use_cassette( "oldtimer" ) do
      u = GwtUser.new( "account_with_sites" )

        it "should have a Crawl Issues feed" do
          u.crawlissues.css( "feed/title" ).text.should == "Crawl Issues"
        end
        it "'s crawl issues feed should contain crawl issues" do
          u.crawlissues.css( "entry" ).size.should be > 0
        end

      use_vcr_cassette "keywords" do
        it "should have a keywords feed" do
         u.keywords.css( "title" ).text.should == "Keywords"
        end
        it "'s keywords feed should contain some keywords" do
         u.keywords.xpath( "//wt:keyword", "wt" => GwtUser::XML_NS).size.should be > 0
        end
      end

      use_vcr_cassette "messages" do
        it "should have a messages feed" do
          u.messages.css( "title" ).text.should == "Messages"
        end
        it "'s messages feed should contain messages" do
          pending "how do i make messages appear in my account?"
          u.messages.css( "entry" ).size.should be > 0
        end
      end

      use_vcr_cassette "sitemaps" do
        it "'s title should be the parent site" do
          u.sitemaps.css( "title" ).text.should == CGI.unescape(TEST_SITE )
        end
      end

      use_vcr_cassette "sites" do
        it "should contain entries" do
          u.sites.css( "entry" ).size.should be > 0
        end
      end

    end # end vcr context
  end # end rspec context

end
