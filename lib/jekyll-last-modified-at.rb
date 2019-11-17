# frozen_string_literal: true

module Jekyll
  module LastModifiedAt
    autoload :VERSION, 'jekyll-last-modified-at/version'
    autoload :Executor, 'jekyll-last-modified-at/executor'
    autoload :Determinator, 'jekyll-last-modified-at/determinator'
    autoload :Tag, 'jekyll-last-modified-at/tag'
    autoload :Hook, 'jekyll-last-modified-at/hook'
    autoload :Git, 'jekyll-last-modified-at/git'

    PATH_CACHE = {} # rubocop:disable Style/MutableConstant
    REPO_CACHE = {} # rubocop:disable Style/MutableConstant
  end
end
