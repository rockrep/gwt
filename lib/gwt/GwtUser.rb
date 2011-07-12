class GwtUser
  require "gdata"
  require "nokogiri"

  attr_accessor :kind, :client

  GWT_API     = "https://www.google.com/webmasters/tools/feeds"
  XML_NS      = "http://schemas.google.com/webmasters/tools/2007"

  def initialize( kind = "new_account" )
    @kind = kind
    @credentials = YAML.load_file( "credentials.yml" )[ kind ]
    @client = GData::Client::WebmasterTools.new
    @client.clientlogin( @credentials["user"], @credentials["password"] )
  end

  def crawlissues
    get_feed( "#{GWT_API}/#{TEST_SITE}/crawlissues/" )
  end

  def keywords
    get_feed( "#{GWT_API}/#{TEST_SITE}/keywords/" )
  end

  def messages
    get_feed( "#{GWT_API}/messages/" )
  end

  def sitemaps
    get_feed( "#{GWT_API}/#{TEST_SITE}/sitemaps/" )
  end

  def sites
    get_feed( "#{GWT_API}/sites/" )
  end

  def add_site
    #<atom:entry xmlns:atom='http://www.w3.org/2005/Atom'>
    #<atom:content src="http://www.example.com/" />
    #</atom:entry>
  end

  def add_site( data )
    @client.post( "#{GWT_API}/sites/", data )
  end

  def delete_site( site )
    raise "no site given" unless site
    @client.delete( "#{GWT_API}/sites/#{CGI.escape(site)}" )
  end

  def verify_site( site, data )
    raise "no site given" unless site
    raise "no data given" unless data
    @client.put( "#{GWT_API}/sites/#{CGI.escape(site)}", data )
  end

  private

  def get_feed( uri )
    Nokogiri::XML( @client.get( uri ).to_xml.to_s )
  end

end
