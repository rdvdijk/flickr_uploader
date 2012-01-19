# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "flickr_uploader/version"

Gem::Specification.new do |s|
  s.name        = "flickr_uploader"
  s.version     = FlickrUploader::VERSION
  s.authors     = ["Roel van Dijk"]
  s.email       = ["roel@rustradio.org"]
  s.homepage    = "http://github.com/rdvdijk/flickr_uploader"
  s.summary     = %q{Uploads a folder of photos to a Flickr photoset}
  s.description = %q{Automatically creates photosets on Flickr and uploads all pictures. Also splits up large collections of photos into separate photosets to fit in Flickr's 500 photos per photoset limit.}

  s.rubyforge_project = "flickr_uploader"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "flickr_fu"
  s.add_runtime_dependency "thor"
  s.add_runtime_dependency "rb-readline"
  s.add_runtime_dependency "progressbar"

  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
  s.add_development_dependency "simplecov"
end
