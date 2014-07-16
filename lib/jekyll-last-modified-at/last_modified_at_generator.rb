module Jekyll
  module JekyllLastModifiedAt
    class LastModifiedAtGenerator << Generator

      def generate(site)
        %w(posts pages docs_to_write).each do |type|
          site.send(type).each do |item|
            item.data['last_modified_at'] = LastModifiedAt.new(site.source, item.path)
          end
        end
      end

    end
  end
end