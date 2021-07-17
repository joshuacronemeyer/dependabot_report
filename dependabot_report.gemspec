# frozen_string_literal: true

require_relative "lib/dependabot_report/version"

Gem::Specification.new do |spec|
  spec.name          = "dependabot_report"
  spec.version       = DependabotReport::VERSION
  spec.authors       = ["Josh Cronemeyer"]
  spec.email         = ["joshuacronemeyer@gmail.com"]

  spec.summary       = "Generate documentation from Github Dependabot"
  spec.description   = "Dependabot artifacts are all locked up in github, but sometimes you need to share that information with people who don't have access to your repo. Now you can."
  spec.homepage      = "https://github.com/joshuacronemeyer/dependabot_report"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage + "/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 1.1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
