
module Jekyll
  module LastModifiedAt
    autoload :VERSION, 'jekyll-last-modified-at/version'
    autoload :Executor, 'jekyll-last-modified-at/executor'
    autoload :Determinator, 'jekyll-last-modified-at/determinator'
    autoload :Tag, 'jekyll-last-modified-at/tag'
    autoload :Hook, 'jekyll-last-modified-at/hook'

    Tag ; Hook

    PATH_CACHE = {}
  end
end
