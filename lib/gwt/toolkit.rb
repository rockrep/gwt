module GWT
  class Toolkit

    def awaken
      puts "i'm up!"
    end

    def login
      @credentials = YAML.load_file( "credentials.yml" )
      client = GData::Client::WebmasterTools.new
      client.clientlogin( @credentials["user"], @credentials["password"] )
    end

 end
end
