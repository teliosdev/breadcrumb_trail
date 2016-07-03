# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "breadcrumb_trail/version"

Gem::Specification.new do |spec|
  spec.name          = "breadcrumb_trail"
  spec.version       = BreadcrumbTrail::VERSION
  spec.authors       = ["Jeremy Rodi"]
  spec.email         = ["redjazz96@gmail.com"]
  spec.summary       = %q{A basic breadcrumb trail plugin.}
  spec.description   = %q{A breadcrumb trail plugin that provides shortcuts to make your life easier.}
  spec.homepage      = "https://github.com/medcat/breadcrumb_trail"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec-rails", "~> 3.0"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "codeclimate-test-reporter"

  # I don't know what 6 will be like...
  spec.add_dependency "rails", ">= 3.0", "< 5.1"

end
