module Jekyll
  class LastModifiedAtTag < Liquid::Tag
    def initialize(tag_name, format, tokens)
      super
      @format = format.empty? ? nil : format.strip
    end

    def render(context)
      site_source = context.registers[:site].source
      article_file = context.environments.first["page"]["path"]
      article_file_path = File.expand_path(article_file, site_source)

      if is_git_repo?(site_source)
        top_level_git_directory = ""
        Dir.chdir(site_source) do
          top_level_git_directory = File.join(`git rev-parse --show-toplevel`.strip, ".git")
        end
        relative_file_path = File.expand_path(article_file_path, top_level_git_directory)
        last_commit_date = IO.popen(['git', '--git-dir', top_level_git_directory, 'log', '--format="%ct"', '--', relative_file_path]).read[/\d+/]
        # last_commit_date can be nil iff the file was not committed.
        last_modified_time = (last_commit_date.nil? || last_commit_date.empty?) ? mtime(article_file_path) : last_commit_date
      else
        last_modified_time = mtime(article_file_path)
      end

      Time.at(last_modified_time.to_i).strftime(@format || "%d-%b-%y")
    end

    def is_git_repo?(site_source)
      Dir.chdir(site_source) do
        `git rev-parse --is-inside-work-tree`.strip == "true"
      end
    rescue
      false
    end

    def mtime(file)
      File.mtime(file)
    end
  end
end

Liquid::Template.register_tag('last_modified_at', Jekyll::LastModifiedAtTag)
