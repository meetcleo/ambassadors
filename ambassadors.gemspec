# frozen_string_literal: true

require_relative "lib/ambassadors/version"

Gem::Specification.new do |spec|
  spec.name = "ambassadors"
  spec.version = Ambassadors::VERSION
  spec.authors = ["Gavin Morrice"]
  spec.email = ["gavin@gavinmorrice.com"]

  spec.summary = "Immutable, read-only wrappers for domain entities."
  spec.description = <<~STRING
    Ambassadors are frozen, read-only wrappers around domain entities, providing a stable interface
    that is safe to pass across domain boundaries in a modular monolith.
  STRING
  spec.homepage = "https://github.com/meetcleo/ambassadors"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore test/ .github/ .circleci/ .rubocop.yml .yardopts Guardfile])
    end
  end

  spec.require_paths = ["lib"]
end
