# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'letteropend/version'

Gem::Specification.new do |spec|
  spec.name          = "letteropend"
  spec.version       = Letteropend::VERSION
  spec.authors       = ["Jesse Jurman"]
  spec.email         = ["j.r.jurman@gmail.com"]
  spec.summary       = "exposes films and lists from letterboxd.com"
  spec.description   = "Letteropend is a gem that exposes films and lists stored on letterboxd.com"
  spec.homepage      = "https://github.com/JRJurman/Letteropend"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri"
  spec.add_dependency "open-uri"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
end
