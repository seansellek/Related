# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'related/version'

Gem::Specification.new do |spec|
  spec.name          = "related"
  spec.version       = Related::VERSION
  spec.authors       = ["Sean Sellek"]
  spec.email         = ["me@seansellek.com"]

  spec.summary       = %q{A simple relational algebra engine.}
  spec.description   = %q{Related is a simple utility that allows you to define relations and perform relational algebra on them. It is great for students who are learning RA for the first time, but can also be used by veterans as a scratch pad when SQl and a RDMS doesn't fit the bill.}
  spec.homepage      = "https://github.com/seansellek/related"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "pry-byebug"
  
end
