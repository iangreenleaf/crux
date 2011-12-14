# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "crux/version"

Gem::Specification.new do |s|
  s.name        = "crux"
  s.version     = Crux::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ian Young"]
  s.email       = ["ian.greenleaf@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Build Chrome extensions from Greasemonkey scripts}
  s.description = %q{Build Chrome extensions from Greasemonkey scripts}

  s.rubyforge_project = "crux"

  s.add_dependency "json"
  s.add_dependency "crxmake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "fakeweb"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
