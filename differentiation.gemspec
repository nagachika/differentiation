# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'differentiation/version'

Gem::Specification.new do |spec|
  spec.name          = "differentiation"
  spec.version       = Differentiation::VERSION
  spec.authors       = ["nagachika"]
  spec.email         = ["nagachika@ruby-lang.org"]

  spec.summary       = %q{Make Ruby Differentiable.}
  spec.description   = %q{differentiation.gem implement a kind of Automatic differentiation algorithm. It can convert Method/Proc to differentiable version.}
  spec.homepage      = "https://github.com/nagachika/differentiation"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "test-unit"
end
