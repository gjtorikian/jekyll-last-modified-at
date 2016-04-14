
module Jekyll
  module LastModifiedAt
    autoload :VERSION, 'jekyll-last-modified-at/version'
    autoload :Executor, 'jekyll-last-modified-at/executor'
    autoload :Determinator, 'jekyll-last-modified-at/determinator'
    autoload :Generator, 'jekyll-last-modified-at/generator'
    autoload :Tag, 'jekyll-last-modified-at/tag'
    autoload :Hook, 'jekyll-last-modified-at/hook'

    Generator ; Tag ; Hook

    PATH_CACHE = {}
  end
end
