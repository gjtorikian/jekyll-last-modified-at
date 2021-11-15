# frozen_string_literal: true

module Jekyll
  module LastModifiedAt
    module Hook
      def self.add_determinator_proc
        proc { |item|
          format = item.site.config.dig('last-modified-at', 'date-format')
          use_git_cache = item.site.config.dig('last-modified-at', 'use-git-cache')
          item.data['last_modified_at'] = Determinator.new(item.site.source, item.relative_path,
                                                           format, use_git_cache)
          if item.site.config.dig('last-modified-at', 'set-page-date')
            # The "date" field will be converted to a string first by Jekyll and it must be
            # in the format given below: https://jekyllrb.com/docs/variables/#page-variables
            item.data['date'] = Determinator.new(item.site.source, item.relative_path,
                                                 '%Y-%m-%d %H:%M:%S %z', use_git_cache, true)
          end
        }
      end

      Jekyll::Hooks.register :posts, :post_init, &Hook.add_determinator_proc
      Jekyll::Hooks.register :pages, :post_init, &Hook.add_determinator_proc
      Jekyll::Hooks.register :documents, :post_init, &Hook.add_determinator_proc
    end
  end
end
