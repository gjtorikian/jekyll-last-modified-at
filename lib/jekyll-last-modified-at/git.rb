# frozen_string_literal: true

module Jekyll
  module LastModifiedAt
    class Git
      attr_reader :site_source

      def initialize(site_source)
        @site_source = site_source
        @is_git_repo = nil
        @lcd_cache = {}
        @lce_cache = {}
      end

      def top_level_directory
        return nil unless git_repo?

        @top_level_directory ||= begin
          Dir.chdir(@site_source) do
            @top_level_directory = File.join(Executor.sh('git', 'rev-parse', '--show-toplevel'), '.git')
          end
                                 rescue StandardError
                                   ''
        end
      end

      def git_repo?
        return @is_git_repo unless @is_git_repo.nil?

        @is_git_repo = begin
          Dir.chdir(@site_source) do
            Executor.sh('git', 'rev-parse', '--is-inside-work-tree').eql? 'true'
          end
                       rescue StandardError
                         false
        end
      end

      def last_commit_date(path, use_git_cache = false) # rubocop:disable Style/OptionalBooleanParameter
        if use_git_cache
          build_cache if @lcd_cache.empty?
          @lcd_cache[path]
        else
          Executor.sh(
            'git',
            '--git-dir',
            top_level_directory,
            'log',
            '-n',
            '1',
            '--format="%ct"',
            '--',
            path
          )[/\d+/]
        end
      end

      def first_commit_date(path, use_git_cache = false) # rubocop:disable Style/OptionalBooleanParameter
        if use_git_cache
          build_cache if @lce_cache.empty?
          @lce_cache[path]
        else
          Executor.sh(
            'git',
            '--git-dir',
            top_level_directory,
            'log',
            '--format="%ct"',
            '--',
            path
          ).split("\n")[-1][/\d+/]
        end
      end

      private

      # generates hash of `path => unix time stamp (string)`
      def build_cache
        # example output:
        #
        # %these-files-modified-at:1621042992
        #
        # Dockerfile.production
        # %these-files-modified-at:1621041929
        #
        # assets/css/style.52513a5600efd4015668ccb9b702256e.css
        # assets/css/style.52513a5600efd4015668ccb9b702256e.css.gz
        lines = Executor.sh(
          'git',
          '--git-dir',
          top_level_directory,
          'log',
          '--name-only',
          '--date=unix',
          '--pretty=%%these-files-modified-at:%ct'
        )

        timestamp = nil
        lines.split("\n").each do |line|
          next if line.empty?

          if line.start_with?('%these-files-modified-at:')
            # new record
            timestamp = line.split(':')[1]
            next
          end

          @lcd_cache[line] = timestamp unless @lcd_cache.key?(line)
          @lce_cache[line] = timestamp
        end
      end
    end
  end
end
