require_relative 'lib/org_incineration/version'

Gem::Specification.new do |spec|
  spec.name          = "org_incineration"
  spec.version       = OrgIncineration::VERSION
  spec.authors       = ["Sagar Patil"]
  spec.email         = ["sagar.patil.smp@gmail.com"]

  spec.summary       = "Organization Incineration gem"
  spec.description   = "This is a gem that is used to add the Organization's Incineration functionality in your application."
  spec.homepage      = "http://www.bigbinary.com"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "http://www.bigbinary.com"
  spec.metadata["changelog_uri"] = "http://www.bigbinary.com"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
