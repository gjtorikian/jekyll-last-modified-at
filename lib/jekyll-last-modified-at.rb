require "open3"

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

      unless File.exists? article_file_path
        raise Errno::ENOENT, "#{article_file_path} does not exist!"
      end 

      if is_git_repo?(site_source)
        top_level_git_directory = ""
        Dir.chdir(site_source) do
          top_level_git_directory = File.join(sh("git", "rev-parse", "--show-toplevel"), ".git")
        end
        relative_file_path = Pathname.new(article_file_path).relative_path_from(Pathname.new(File.dirname(top_level_git_directory))).to_s
        last_commit_date = sh('git', '--git-dir', top_level_git_directory, 'log', '--format="%ct"', '--', relative_file_path)[/\d+/]
        # last_commit_date can be nil iff the file was not committed.
        last_modified_time = (last_commit_date.nil? || last_commit_date.empty?) ? mtime(article_file_path) : last_commit_date
      else
        last_modified_time = mtime(article_file_path)
      end

      Time.at(last_modified_time.to_i).strftime(@format || "%d-%b-%y")
    end

    def is_git_repo?(site_source)
      Dir.chdir(site_source) do
        sh("git", "rev-parse", "--is-inside-work-tree") == "true"
      end
    rescue
      false
    end

    def mtime(file)
      File.mtime(file)
    end
    
    private :sh
    def sh(*args)
      Open3.popen2(*args) do |stdin, stdout, wait_thr|
        exit_status = wait_thr.value # wait for it...
        output = stdout.read
        output ? output.strip : nil
      end
    end
  end
end

Liquid::Template.register_tag('last_modified_at', Jekyll::LastModifiedAtTag)
