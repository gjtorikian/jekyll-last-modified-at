require 'open3'

module Jekyll
  module LastModifiedAt
    module Executor
      def self.sh(*args)
        Open3.popen2(*args) do |stdin, stdout, wait_thr|
          exit_status = wait_thr.value # wait for it...
          output = stdout.read
          output ? output.strip : nil
        end
      end
    end
  end
end
