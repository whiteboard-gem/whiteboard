# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'whiteboard/version'

Gem::Specification.new do |spec|
  spec.name          = "whiteboard"
  spec.version       = Whiteboard::VERSION
  spec.authors       = ["Nathan Bashaw"]
  spec.email         = ["nbashaw@gmail.com"]
  spec.summary       = %q{An intellectually satisfying way to start new rails apps.}
  spec.homepage      = "http://github.com/nbashaw/whiteboard"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
