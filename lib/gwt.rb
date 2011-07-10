module GWT

  require 'gwt/authentication_request'

    def self.do

      @credentials = YAML.load_file( "credentials.yml" )

      client = GData::Client::WebmasterTools.new
      client.clientlogin( @credentials["user"], @credentials["password"] )

    end
  end
end

