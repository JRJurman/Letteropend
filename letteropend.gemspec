# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'letteropend/version'

Gem::Specification.new do |spec|
  spec.name          = "letteropend"
  spec.version       = Letteropend::VERSION
  spec.authors       = ["Jesse Jurman"]
  spec.email         = ["jrjurman@gmail.com"]
  spec.summary       = "Scripts and Functions that let you peek at letterboxd films."
  spec.homepage      = "https://github.com/JRJurman/Letteropend"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "colorize"
  spec.add_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
end
