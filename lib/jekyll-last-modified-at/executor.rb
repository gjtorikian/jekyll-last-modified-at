# frozen_string_literal: true

require 'posix/spawn'

module Jekyll
  module LastModifiedAt
    module Executor
      extend POSIX::Spawn

      def self.sh(*args)
        r, w = IO.pipe
        e, eo = IO.pipe
        pid = spawn(*args,
                    :out => w, r => :close,
                    :err => eo, e => :close)

        if pid.positive?
          w.close
          eo.close
          out = r.read
          err = e.read
          ::Process.waitpid(pid)
          "#{out} #{err}".strip if out
        end
      ensure
        [r, w, e, eo].each do |io|
          begin
                                   io.close
          rescue StandardError
            nil
                                 end
        end
      end
    end
  end
end
