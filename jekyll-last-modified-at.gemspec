require File.expand_path('../lib/jekyll-last-modified-at/version.rb', __FILE__)
Gem::Specification.new do |s|
  s.name                  = "jekyll-last-modified-at"
  s.version               = Jekyll::LastModifiedAt::VERSION
  s.summary               = "A liquid tag for Jekyll to indicate the last time a file was modified."
  s.authors               = "Garen J. Torikian"
  s.homepage              = "https://github.com/gjtorikian/jekyll-last-modified-at"
  s.license               = "MIT"
  s.files                 = Dir["lib/**/*.rb"]

  s.add_dependency "jekyll", ENV['JEKYLL_VERSION'] ? "~> #{ENV['JEKYLL_VERSION']}" : ">= 2.0"
  s.add_dependency "posix-spawn", "~> 0.3.9"
  s.add_development_dependency "rspec", "~> 2.13.0"
  s.add_development_dependency "rake"
  s.add_development_dependency "spork"
  s.add_development_dependency "redcarpet"
end
