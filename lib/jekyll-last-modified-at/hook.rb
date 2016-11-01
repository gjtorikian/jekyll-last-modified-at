module Jekyll
  module LastModifiedAt
    module Hook
      def self.add_determinator_proc
        proc { |item|
          item.data['last_modified_at'] = Determinator.new(item.site.source, item.path)
        }
      end

      Jekyll::Hooks.register :posts, :post_init, &Hook.add_determinator_proc
      Jekyll::Hooks.register :pages, :post_init, &Hook.add_determinator_proc
      Jekyll::Hooks.register :documents, :post_init, &Hook.add_determinator_proc
    end
  end
end
