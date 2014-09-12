module Jekyll
  module LastModifiedAt
    class Determinator
      attr_reader :site_source, :opts

      def initialize(site_source, page_path, opts = {})
        @site_source = site_source
        @page_path   = page_path
        @opts        = opts
      end

      def formatted_last_modified_date
        return PATH_CACHE[@page_path] unless PATH_CACHE[@page_path].nil?
        last_modified = last_modified_at_time.strftime(format)
        PATH_CACHE[@page_path] = last_modified
        last_modified
      end

      def last_modified_at_time
        unless File.exists? absolute_path_to_article
          raise Errno::ENOENT, "#{absolute_path_to_article} does not exist!"
        end

        Time.at(last_modified_at_unix.to_i)
      end

      def last_modified_at_unix
        if is_git_repo?(site_source)
          last_commit_date = Executor.sh(
            'git',
            '--git-dir',
            top_level_git_directory,
            'log',
            '--format="%ct"',
            '--',
            relative_path_from_git_dir
          )[/\d+/]
          # last_commit_date can be nil iff the file was not committed.
          (last_commit_date.nil? || last_commit_date.empty?) ? mtime(absolute_path_to_article) : last_commit_date
        else
          mtime(absolute_path_to_article)
        end
      end

      def to_s
        @to_s ||= formatted_last_modified_date
      end

      def to_liquid
        @to_liquid ||= last_modified_at_time
      end

      def format
        opts['format'] ||= "%d-%b-%y"
      end

      def format=(new_format)
        opts['format'] = new_format
      end

      private

      def absolute_path_to_article
        @article_file_path ||= Jekyll.sanitized_path(site_source, @page_path)
      end

      def relative_path_from_git_dir
        return nil unless is_git_repo?(site_source)
        @relative_path_from_git_dir ||= Pathname.new(absolute_path_to_article)
          .relative_path_from(
            Pathname.new(File.dirname(top_level_git_directory))
          ).to_s
      end

      def top_level_git_directory
        @top_level_git_directory ||= begin
          Dir.chdir(site_source) do
            top_level_git_directory = File.join(Executor.sh("git", "rev-parse", "--show-toplevel"), ".git")
          end
        rescue
          ""
        end
      end

      def is_git_repo?(site_source)
        @is_git_repo ||= begin
          Dir.chdir(site_source) do
            Executor.sh("git", "rev-parse", "--is-inside-work-tree").eql? "true"
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
