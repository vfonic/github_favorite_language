# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'github_favorite_language/version'

Gem::Specification.new do |spec|
  spec.name          = "github_favorite_language"
  spec.version       = GithubFavoriteLanguage::VERSION
  spec.authors       = ["Viktor Fonic"]
  spec.email         = ["viktor.fonic@gmail.com"]

  spec.summary       = "Find out any GitHub user's favorite language!"
  spec.homepage      = "https://github.com/vfonic/github_favorite_language"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", '~> 3.3.0'
end
