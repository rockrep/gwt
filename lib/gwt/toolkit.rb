module GWT
  class Toolkit

  require 'gdata'

    def awaken
      puts "i'm up!"
    end

    def login
      @credentials = YAML.load_file( "credentials.yml" )
      client = GData::Client::WebmasterTools.new
      client.clientlogin( @credentials["user"], @credentials["password"] )
      client
    end

    def sites
      # FIXME go Class-level, set this stuff up once per instance, etc.
      @credentials = YAML.load_file( "credentials.yml" )
      client = GData::Client::WebmasterTools.new
      client.clientlogin( @credentials["user"], @credentials["password"] )

      SITES_FEED = "https://www.google.com/webmasters/tools/feeds/sites/"
      feed = client.get( SITES_FEED ).to_xml

      feed.elements.each('entry') do |entry|
        puts 'title: ' + entry.elements['title'].text
        puts 'type: ' + entry.elements['category'].attribute('label').value
        puts 'updated: ' + entry.elements['updated'].text
        puts 'id: ' + entry.elements['id'].text
        
        # Extract the href value from each <atom:link>
        links = {}
        entry.elements.each('link') do |link|
          links[link.attribute('rel').value] = link.attribute('href').value
        end
        puts links.to_s
      end

    end

 end
end
