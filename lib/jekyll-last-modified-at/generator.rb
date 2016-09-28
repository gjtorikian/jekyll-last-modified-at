module Jekyll
  module LastModifiedAt
    class Generator < Jekyll::Generator

      def generate(site)
        %w(posts pages docs_to_write).each do |type|
          items = if type == 'posts' then
            site.posts.docs
          else
            site.send(type)
          end

          items.each do |item|
            item.data['last_modified_at'] = Determinator.new(site.source, item.path)
          end
        end
      end

    end
  end
end
