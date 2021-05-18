# frozen_string_literal: true

module Jekyll
  module LastModifiedAt
    module Hook
      def self.add_determinator_proc
        proc { |item|
          format = item.site.config.dig('last-modified-at', 'date-format')
          use_git_cache = item.site.config.dig('last-modified-at', 'use-git-cache')
          item.data['last_modified_at'] = Determinator.new(item.site.source, item.path,
                                                           format, use_git_cache)
        }
      end

      Jekyll::Hooks.register :site, :after_reset do |site|
        use_git_cache = site.config.dig('last-modified-at', 'use-git-cache')
        if use_git_cache
          # flush the caches so we can detect commits while server is running
          Determinator.repo_cache = {}
          Determinator.path_cache = {}
        end
      end

      Jekyll::Hooks.register :posts, :post_init, &Hook.add_determinator_proc
      Jekyll::Hooks.register :pages, :post_init, &Hook.add_determinator_proc
      Jekyll::Hooks.register :documents, :post_init, &Hook.add_determinator_proc
    end
  end
end
