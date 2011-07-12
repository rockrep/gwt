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
  c.stub_with :fakeweb
  c.default_cassette_options = { :record => :new_episodes }
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
end

describe "GWT" do
  TEST_SITE = "http%3A%2F%2F140proof.com%2F"

  context "new account" do
    use_vcr_cassette

    before(:each) do
      @u = GwtUser.new( "new_account" )
    end

    it "should have a messages feed" do
      @u.messages.css( "title" ).text.should == "Messages"
    end

    it "messages feed should be empty" do
      @u.messages.css( "entry" ).size.should be == 0
    end

    it "should contain no sites" do
      @u.sites.css( "entry" ).size.should be == 0
    end

  end

  context "account with sites" do
    use_vcr_cassette

    before(:each) do
      @u = GwtUser.new( "account_with_sites" )
    end

    it "should have a Crawl Issues feed" do
      @u.crawlissues.css( "feed/title" ).text.should == "Crawl Issues"
    end

    it "crawl issues feed should contain crawl issues" do
      @u.crawlissues.css( "entry" ).size.should be > 0
    end

    it "should have a keywords feed" do
      @u.keywords.css( "title" ).text.should == "Keywords"
    end

    it "keywords feed should contain some keywords" do
      @u.keywords.xpath( "//wt:keyword", "wt" => GwtUser::XML_NS).size.should be > 0
    end

    it "should have a messages feed" do
      @u.messages.css( "title" ).text.should == "Messages"
    end

    # it "messages feed should contain messages" do
    #   pending "how do i make messages appear in my account?"
    #   @u.messages.css( "entry" ).size.should be > 0
    # end

    it "sitemaps feed should contain the parent site" do
      @u.sitemaps.css( "title" ).text.should == CGI.unescape( TEST_SITE )
    end

    it "sites feed should contain entries" do
      @u.sites.css( "entry" ).size.should be > 0
    end

  end

  context "add new site" do
    use_vcr_cassette

    before(:each) do
      @u = GwtUser.new( "new_account" )
      @site = "http://onebuttondeploy.com/"
    end

    it "should succeed" do
      @post_data = <<-XML
      <atom:entry xmlns:atom='http://www.w3.org/2005/Atom'>
        <atom:content src="#{@site}" />
      </atom:entry>
      XML
      @response = @u.add_site( @post_data )
      @response.status_code.should == 201
    end

    it "sites feed should contain the new site" do
      @u.sites.css( "entry title" ).text.should == @site
    end
  end
  
  context "verify a site" do
    use_vcr_cassette

    before(:each) do
      @u = GwtUser.new( "new_account" )
      @site = "http://onebuttondeploy.com/"
    end

    it "should succeed" do
      @verify_xml = <<-XML
      <atom:entry xmlns:atom="http://www.w3.org/2005/Atom"
          xmlns:wt="http://schemas.google.com/webmasters/tools/2007">
        <atom:id>#{@site}/sitemap.xml</atom:id>
        <atom:category scheme='http://schemas.google.com/g/2005#kind'
          term='http://schemas.google.com/webmasters/tools/2007#site-info'/>
        <wt:verification-method type="htmlpage" in-use="true"/>
      </atom:entry>
      XML
      # (or type = metatag)
      response = @u.verify_site( @site, @verify_xml )
      response.status_code.should == 200
    end

    it "sites feed should show that the site is verified" do
      @u.sites.xpath( "//wt:verified", "wt" => GwtUser::XML_NS).text.should == "true"
    end
  end

  context "delete a site" do
    use_vcr_cassette

    before(:each) do
      @u = GwtUser.new( "new_account" )
      @site = "http://onebuttondeploy.com/"
    end

    it "should be deleted" do
      response = @u.delete_site( @site )
      response.status_code.should == 200
    end

    it "sites feed should no longer contain the new site" do
      @u.sites.css( "entry" ).size.should == 0
    end
  end

end
