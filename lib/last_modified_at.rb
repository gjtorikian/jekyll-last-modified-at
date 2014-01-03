module Jekyll
  class LastModifiedAtTag < Liquid::Tag
    def render(context)
      article_file = context.environments.first["page"]["path"]
      article_file_path = File.join(context.registers[:site].source, article_file)
      last_commit_date = `git log --format="%ct" -- .#{article_file_path}`.strip
      last_modified_time = !last_commit_date.empty? ? last_commit_date : File.mtime(article_file_path)
      Time.at(last_modified_time.to_i).strftime("%d-%b-%y")
    end
  end
end

Liquid::Template.register_tag('last_modified_at', Jekyll::LastModifiedAtTag)
