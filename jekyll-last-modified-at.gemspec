Gem::Specification.new do |s|
  s.name                  = "jekyll-last-modified-at"
  s.version               = "0.2.0"
  s.summary               = "A liquid tag for Jekyll to indicate the last time a file was modified."
  s.authors               = "Garen J. Torikian"
  s.homepage              = "https://github.com/gjtorikian/jekyll-last-modified-at"
  s.license               = "MIT"
  s.files                 = ["lib/jekyll-last-modified-at.rb"]

  s.add_dependency "jekyll"
  s.add_development_dependency "rspec", "~> 2.13.0"
  s.add_development_dependency "rake"
end
