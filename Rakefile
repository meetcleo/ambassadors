# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

require "yard"

YARD::Rake::YardocTask.new(:doc) do |t|
  t.options = ["--yardopts", ".yardopts"] # optional, YARD uses this by default
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[test rubocop]
