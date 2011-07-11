module GWT
  class Toolkit

  require "gdata"

    def awaken
      puts "i'm up!"
    end

    def login
      credentials = YAML.load_file( "credentials.yml" )
      client = GData::Client::WebmasterTools.new
      client.clientlogin( credentials["user"], credentials["password"] )
      client
    end

    def sites

      sites_feed = "https://www.google.com/webmasters/tools/feeds/sites/"

      # FIXME go Class-level, set this stuff up once per instance, etc.
      credentials = YAML.load_file( "credentials.yml" )
      client = GData::Client::WebmasterTools.new
      client.clientlogin( credentials["user"], credentials["password"] )

      feed = client.get( sites_feed ).to_xml

      feed.elements.each("entry") do |entry|
        puts "title:        " + entry.elements["title"].text
        puts "verified:     " + entry.elements["wt:verified"].text
        puts "verified via: " + entry.elements["wt:verification-method"].text
      end

    end

 end
end
