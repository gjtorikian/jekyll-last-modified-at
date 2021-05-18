# frozen_string_literal: true

module Jekyll
  module LastModifiedAt
    class Determinator
      @repo_cache = {}
      @path_cache = {}
      class << self
        # attr_accessor so we can flush externally
        attr_accessor :repo_cache
        attr_accessor :path_cache
      end

      attr_reader :site_source, :page_path, :use_git_cache
      attr_accessor :format

      def initialize(site_source, page_path, format = nil, use_git_cache = false) # rubocop:disable Style/OptionalBooleanParameter
        @site_source   = site_source
        @page_path     = page_path
        @format        = format || '%d-%b-%y'
        @use_git_cache = use_git_cache
      end

      def git
        return self.class.repo_cache[site_source] unless self.class.repo_cache[site_source].nil?

        self.class.repo_cache[site_source] = Git.new(site_source)
        self.class.repo_cache[site_source]
      end

      def formatted_last_modified_date
        last_modified_at_time.strftime(@format)
      end

      def last_modified_at_time
        return self.class.path_cache[page_path] unless self.class.path_cache[page_path].nil?

        raise Errno::ENOENT, "#{absolute_path_to_article} does not exist!" unless File.exist? absolute_path_to_article

        self.class.path_cache[page_path] = Time.at(last_modified_at_unix.to_i)
        self.class.path_cache[page_path]
      end

      def last_modified_at_unix
        if git.git_repo?
          last_commit_date = git.last_commit_date(relative_path_from_git_dir, use_git_cache)
          # last_commit_date can be nil iff the file was not committed.
          last_commit_date.nil? || last_commit_date.empty? ? mtime(absolute_path_to_article) : last_commit_date
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

      private

      def absolute_path_to_article
        @absolute_path_to_article ||= Jekyll.sanitized_path(site_source, @page_path)
      end

      def relative_path_from_git_dir
        return nil unless git.git_repo?

        @relative_path_from_git_dir ||= Pathname.new(absolute_path_to_article)
                                                .relative_path_from(
                                                  Pathname.new(File.dirname(git.top_level_directory))
                                                ).to_s
      end

      def mtime(file)
        File.mtime(file).to_i.to_s
      end
    end
  end
end
