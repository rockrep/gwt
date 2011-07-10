require 'vcr'

VCR.config do |c|
  c.cassette_library_dir     = 'fixtures/cassettes'
  c.stub_with                :fakeweb
  c.default_cassette_options = { :record => :new_episodes }
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
end
