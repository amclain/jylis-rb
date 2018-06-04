require_relative "lib/jylis-rb/version"

Gem::Specification.new do |spec|
  spec.name        = "jylis-rb"
  spec.version     = Jylis::VERSION
  spec.date        = Time.now.strftime "%Y-%m-%d"
  spec.summary     = "An idiomatic library for connecting a Ruby project to a Jylis database."
  spec.description = ""
  spec.homepage    = "https://github.com/amclain/jylis-rb"
  spec.authors     = ["Alex McLain"]
  spec.email       = ["alex@alexmclain.com"]
  spec.license     = "MIT"
  
  spec.files =
    [
      "license.txt",
      "README.md",
    ] +
    Dir[
      "lib/**/*",
      "doc/**/*",
    ]
  
  spec.add_dependency "hiredis", "~> 0.6.1"
  spec.add_dependency "oj",      "~> 3.6"

  spec.add_development_dependency "rake",      "~> 12.3"
  spec.add_development_dependency "yard",      "~> 0.9", ">= 0.9.13"
  spec.add_development_dependency "rspec",     "~> 3.7"
  spec.add_development_dependency "rspec-its", "~> 1.2"
  spec.add_development_dependency "fivemat",   "~> 1.3"
  spec.add_development_dependency "pry"
end
