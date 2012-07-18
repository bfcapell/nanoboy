# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nanoboy/version"

Gem::Specification.new do |s|
  s.name        = "nanoboy"
  s.version     = Nanoboy.version
  s.authors     = ["Bernat Foj"]
  s.homepage    = "http://www.github.com/bfcapell/nanoboy"
  s.summary     = %q{Lazy extend ruby classes and modules}
  s.description = %q{Lazy extend ruby classes and modules}

  s.rubyforge_project = "nanoboy"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
