$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "errbit_errorception_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "errbit_errorception_engine"
  s.version     = ErrbitErrorceptionEngine::VERSION
  s.authors     = ["Ben Miller"]
  s.email       = ["ben.miller@cohortsolutions.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of ErrbitErrorceptionEngine."
  s.description = "TODO: Description of ErrbitErrorceptionEngine."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5.2"

  s.add_development_dependency "sqlite3"
end
