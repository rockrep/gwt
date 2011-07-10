# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gwt/version"

Gem::Specification.new do |s|
  s.name        = "gwt"
  s.version     = Gwt::VERSION
  s.authors     = ["John Manoogian III"]
  s.email       = ["jm3@jm3.net"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "gwt"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "gdata"
end
