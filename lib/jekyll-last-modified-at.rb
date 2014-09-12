
module Jekyll
  module LastModifiedAt
    autoload :VERSION, 'jekyll-last-modified-at/version'
    autoload :Executor, 'jekyll-last-modified-at/executor'
    autoload :Determinator, 'jekyll-last-modified-at/determinator'
    autoload :Generator, 'jekyll-last-modified-at/generator'
    autoload :Tag, 'jekyll-last-modified-at/tag'

    Generator ; Tag

    PATH_CACHE = {}
  end
end
