# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'psd/enginedata/version'

Gem::Specification.new do |spec|
  spec.name          = "psd-enginedata"
  spec.version       = PSD::EngineData::VERSION
  spec.authors       = ["Ryan LeFevre"]
  spec.email         = ["meltingice8917@gmail.com"]
  spec.description   = %q{Parser for the markup format used in the PSD file format}
  spec.summary       = %q{Parser for the markup format used in the PSD file format}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = Dir.glob("spec/**/*")
  spec.require_paths = ["lib/psd"]

  spec.add_dependency 'hashie'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rb-fsevent", "~> 0.9"
end
