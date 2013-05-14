# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wcs/version'

Gem::Specification.new do |spec|
  spec.name          = "wcs"
  spec.version       = Wcs::VERSION
  spec.authors       = ["Masahiro TANAKA"]
  spec.email         = ["masa16.tanaka@gmail.com"]
  spec.description   = %q{WCSTools wrapper for Ruby}
  spec.summary       = %q{WCSTools wrapper for Ruby. Currently only wcs.c}
  spec.homepage      = ""
  spec.license       = "MIT"
  spec.extensions    = ["ext/extconf.rb"]

  spec.files         = `git ls-files`.split($/)
#  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.rdoc_options = %w[
    --title Wcs
    --main Wcs
    --exclude mk.*
    --exclude extconf\.rb
    --exclude ext/.*\.h
    --exclude ext/lib/
    --exclude .*\.o
    --exclude wcs\.so
  ]

end
