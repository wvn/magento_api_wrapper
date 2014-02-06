# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'magento_api_wrapper/version'

Gem::Specification.new do |spec|
  spec.name          = "magento_api_wrapper"
  spec.version       = MagentoApiWrapper::VERSION
  spec.authors       = ["Josh Harris"]
  spec.email         = ["harrisjb1@gmail.com"]
  spec.description   = %q{Ruby wrapper for Magento's SOAP API. Allows you to download orders using filters, invoice orders, and update orders as shipped in Magento.}
  spec.summary       = %q{Ruby wrapper for Magento's SOAP API}
  spec.homepage      = "https://github.com/harrisjb/magento_api_wrapper"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "savon", "2.2.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "factory_girl", "~> 4.3.0"
  spec.add_development_dependency "pry", "~> 0.9.12 "
  spec.add_development_dependency "rake", "~> 0.9.6"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "vcr", "~> 2.8.0"
end
