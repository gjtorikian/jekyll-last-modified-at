require File.expand_path('../lib/jekyll-last-modified-at/version.rb', __FILE__)
Gem::Specification.new do |s|
  s.name                  = "jekyll-last-modified-at"
  s.version               = Jekyll::LastModifiedAt::VERSION
  s.summary               = "A liquid tag for Jekyll to indicate the last time a file was modified."
  s.authors               = "Garen J. Torikian"
  s.homepage              = "https://github.com/gjtorikian/jekyll-last-modified-at"
  s.license               = "MIT"
  s.files                 = ["lib/jekyll-last-modified-at.rb"]

  s.add_dependency "jekyll"
  s.add_development_dependency "rspec", "~> 2.13.0"
  s.add_development_dependency "rake"
  s.add_development_dependency "spork"
end
