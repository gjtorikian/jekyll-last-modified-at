module Jekyll
  module JekyllLastModifiedAt
    class LastModifiedAt
      attr_reader :site_source

      def initialize(site_source, page_path, opts = {})
        @site_source = site_source
        @page_path   = page_path
        @opts        = opts
      end

      def last_modified_at_date
        unless File.exists? article_file_path
          raise Errno::ENOENT, "#{article_file_path} does not exist!"
        end

        Time.at(last_modified_time.to_i).strftime(format)
      end

      def last_modified_at_time
        if is_git_repo?(site_source)
          last_commit_date = IO.popen([
            'git',
            '--git-dir',
            top_level_git_directory,
            'log',
            '--format="%ct"',
            '--',
            relative_file_path
          ]).read[/\d+/]
          # last_commit_date can be nil iff the file was not committed.
          (last_commit_date.nil? || last_commit_date.empty?) ? mtime(article_file_path) : last_commit_date
        else
          mtime(article_file_path)
        end
      end

      def to_liquid
        @to_liquid ||= last_modified_at_date
      end

      def format
        opts['format'] ||= "%d-%b-%y"
      end

      def format=(new_format)
        opts['format'] = new_format
      end

      private

      def article_file_path
        @article_file_path ||= Jekyll.sanitized_path(site_source, @page_path)
      end

      def relative_path_from_git_dir
        return nil unless is_git_repo?(site_source)
        @relative_path_from_git_dir ||= Pathname.new(article_file_path)
          .relative_path_from(
            Pathname.new(File.dirname(top_level_git_directory))
          ).to_s
      end

      def top_level_git_directory
        @top_level_git_directory ||= begin
          Dir.chdir(site_source) do
            top_level_git_directory = File.join(`git rev-parse --show-toplevel`.strip, ".git")
          end
        rescue
          ""
        end
      end

      def is_git_repo?(site_source)
        @is_git_repo ||= begin
          Dir.chdir(site_source) do
          `git rev-parse --is-inside-work-tree 2> /dev/null`.strip == "true"
          end
        rescue
          false
        end
      end

      def mtime(file)
        File.mtime(file)
      end
    end
  end
end
