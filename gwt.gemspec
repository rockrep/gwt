# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gwt/version"

Gem::Specification.new do |s|
  s.name        = "gwt"
  s.version     = Gwt::VERSION
  s.authors     = ["John Manoogian III"]
  s.email       = ["jm3@jm3.net"]
  s.homepage    = "http://www.jm3.net/"
  s.summary     = %q{the Google Webmaster Toolkit gem}
  s.description = %q{the Google Webmaster Toolkit gem, by @jm3}

  s.add_dependency "gdata"
  s.add_dependency "sinatra", "= 1.1.3"

  # development only:
  s.add_dependency "fakeweb"
  s.add_dependency "nokogiri"
  s.add_dependency "rake", "= 0.8.7"
  s.add_dependency "rspec"
  s.add_dependency "vcr"

  s.rubyforge_project = "gwt"

  s.files         = `git ls-files`.split("\n")
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
