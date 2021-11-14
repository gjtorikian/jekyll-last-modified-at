# frozen_string_literal: true

module Jekyll
  module LastModifiedAt
    class Determinator
      @repo_cache = {}
      @last_mod_cache = {}
      @first_mod_cache = {}
      class << self
        # attr_accessor so we can flush externally
        attr_accessor :repo_cache
        attr_accessor :last_mod_cache
        attr_accessor :first_mod_cache
      end

      attr_reader :site_source, :page_path, :use_git_cache
      attr_accessor :format

      def initialize(site_source, page_path, format = nil, use_git_cache = false, first_time = false) # rubocop:disable Style/OptionalBooleanParameter
        @site_source   = site_source
        @page_path     = page_path
        @format        = format || '%d-%b-%y'
        @use_git_cache = use_git_cache
        @first_time    = first_time
      end

      def git
        return self.class.repo_cache[site_source] unless self.class.repo_cache[site_source].nil?

        self.class.repo_cache[site_source] = Git.new(site_source)
        self.class.repo_cache[site_source]
      end

      def formatted_last_modified_date
        last_modified_at_time.strftime(@format)
      end

      def formatted_first_modified_date
        first_modified_at_time.strftime(@format)
      end

      def first_modified_at_time
        return self.class.first_mod_cache[page_path] unless self.class.first_mod_cache[page_path].nil?

        raise Errno::ENOENT, "#{absolute_path_to_article} does not exist!" unless File.exist? absolute_path_to_article

        self.class.first_mod_cache[page_path] = Time.at(first_modified_at_unix.to_i)
        self.class.first_mod_cache[page_path]
      end

      def first_modified_at_unix
        if git.git_repo?
          first_commit_date = git.first_commit_date(relative_path_from_git_dir, use_git_cache)
          first_commit_date.nil? || first_commit_date.empty? ? ctime(absolute_path_to_article) : first_commit_date
        else
          ctime(absolute_path_to_article)
        end
      end

      def last_modified_at_time
        return self.class.last_mod_cache[page_path] unless self.class.last_mod_cache[page_path].nil?

        raise Errno::ENOENT, "#{absolute_path_to_article} does not exist!" unless File.exist? absolute_path_to_article

        self.class.last_mod_cache[page_path] = Time.at(last_modified_at_unix.to_i)
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
        if @first_time
          @to_s ||= formatted_first_modified_date
        else
          @to_s ||= formatted_last_modified_date
        end
      end

      def to_liquid
        if @first_time
          @to_liquid ||= first_modified_at_time
        else
          @to_liquid ||= last_modified_at_time
        end
      end

      def to_time
        to_liquid
      end

      def strftime(*args)
        return to_liquid().strftime(*args)
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

      def ctime(file)
        File.ctime(file).to_i.to_s
      end
    end
  end
end
