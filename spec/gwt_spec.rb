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


describe "toolkit" do

  def creds
    YAML.load_file( "credentials.yml" )
  end

  def sites_feed
    credentials = creds
    sites_feed = "https://www.google.com/webmasters/tools/feeds/sites/"
    client = GData::Client::WebmasterTools.new
    client.clientlogin( credentials["user"], credentials["password"] )
    feed = client.get( sites_feed ).to_xml
  end

  context "sites feed" do
    use_vcr_cassette "sites_feed"
    it "should contain entries" do
      feed =  Nokogiri::XML( sites_feed.to_s )
      entries = feed.css( "entry" )
      entries.size.should_not != 0
    end
  end

end
