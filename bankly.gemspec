
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bankly/version"

Gem::Specification.new do |spec|
  spec.name          = "bankly"
  spec.version       = Bankly::VERSION
  spec.authors       = ["Henrique Dell"]
  spec.email         = ["henrique@mobile2you.com.br"]

  spec.summary       = %q{Bankly Baas API Gem}
  spec.description   = %q{Bankly Baas API Gem}
  spec.license       = "MIT"


  spec.files = Dir['lib/**/*.rb']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "httparty"
end
