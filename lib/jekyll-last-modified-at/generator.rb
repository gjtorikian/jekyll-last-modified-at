module Jekyll
  module LastModifiedAt
    class Generator < Jekyll::Generator

      def generate(site)
        %w(posts pages docs_to_write).each do |type|
          site.send(type).each do |item|
            item.data['last_modified_at'] = Determinator.new(site.source, item.path)
          end
        end
      end

    end
  end
end if Jekyll::VERSION < '3.0'
