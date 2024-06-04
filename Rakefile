# frozen_string_literal: true

require "bundler"
Bundler::GemHelper.install_tasks

require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

desc "Test the project"
task :test do
  Rake::Task["spec"].invoke
end

require "rubocop/rake_task"

RuboCop::RakeTask.new(:rubocop)

require "bundler/gem_tasks"
require "rubygems/package_task"
GEMSPEC = Bundler.load_gemspec("jekyll-last-modified-at.gemspec")
gem_path = Gem::PackageTask.new(GEMSPEC).define
desc "Package the ruby gem"
task "package" => [gem_path]
