module GWT
  def self.do

    @credentials = YAML.load_file( "credentials.yml" )

    client = GData::Client::WebmasterTools.new
    client.clientlogin( @credentials["user"], @credentials["password"] )
  end
end

