require "rubygems"

require "fakeweb"
require "gdata"
require "net/https"
require "nokogiri"
require "rspec"
require "spec_helper"
require "test/unit"
require "vcr"

VCR.config do |c|
  c.cassette_library_dir = "fixtures/cassettes"
  c.stub_with :webmock # or :fakeweb
end

GWT_API = "https://www.google.com/webmasters/tools/feeds"
GWT_XML_NS = "http://schemas.google.com/webmasters/tools/2007"
TEST_SITE = "http%3A%2F%2F140proof.com%2F"

describe "toolkit" do

  def creds
    YAML.load_file( "credentials.yml" )["new_account"]
  end

  def get_gwt_feed( uri )
    credentials = creds
    client = GData::Client::WebmasterTools.new
    client.clientlogin( credentials["user"], credentials["password"] )
    Nokogiri::XML( client.get( uri ).to_xml.to_s )
  end

  def crawlissues_feed
    get_gwt_feed( "#{GWT_API}/#{TEST_SITE}/crawlissues/" )
  end

  def keywords_feed
    get_gwt_feed( "#{GWT_API}/#{TEST_SITE}/keywords/" )
  end

  def messages_feed
    get_gwt_feed( "#{GWT_API}/messages/" )
  end

  def sitemaps_feed
    get_gwt_feed( "#{GWT_API}/#{TEST_SITE}/sitemaps/" )
  end

  def sites_feed
    get_gwt_feed( "#{GWT_API}/sites/" )
  end
  
  context "new GWT account" do

    use_vcr_cassette "messages_feed"
    it "should be named 'Messages'" do
      messages_feed.css( "title" ).text.should == "Messages"
    end

    it "should contain no messages" do
      messages_feed.css( "entry" ).size.should be == 0
    end

    use_vcr_cassette "sites_feed"
    it "should contain no sites" do
      sites_feed.css( "entry" ).size.should be == 0
    end

  end

  # context "crawl issues feed" do
  #   use_vcr_cassette "crawlissues_feed"
  #   it "should be named 'Crawl Issues'" do
  #     crawlissues_feed.css( "feed/title" ).text.should == "Crawl Issues"
  #   end
  #   it "should contain crawl issues" do
  #     crawlissues_feed.css( "entry" ).size.should be > 0
  #   end
  # end

  # context "keywords feed" do
  #   use_vcr_cassette "keywords_feed"
  #   it "should be named 'Keywords'" do
  #     keywords_feed.css( "title" ).text.should == "Keywords"
  #   end
  #   it "should contain some keywords" do
  #     keywords_feed.xpath( "//wt:keyword", "wt" => GWT_XML_NS).size.should be > 0
  #   end
  # end

  # context "messages feed" do
  #   use_vcr_cassette "messages_feed"
  #   it "should be named 'Messages'" do
  #     messages_feed.css( "title" ).text.should == "Messages"
  #   end
  #   it "should contain messages" do
  #     messages_feed.css( "entry" ).size.should be > 0
  #   end
  # end

  # context "sitemaps feed" do
  #   use_vcr_cassette "sitemaps_feed"
  #   it "'s title should be the parent site" do
  #     sitemaps_feed.css( "title" ).text.should == CGI.unescape(TEST_SITE )
  #   end
  # end

  # context "sites feed" do
  #   use_vcr_cassette "sites_feed"
  #   it "should contain entries" do
  #     sites_feed.css( "entry" ).size.should be > 0
  #   end
  # end

end
