require 'posix/spawn'

module Jekyll
  module LastModifiedAt
    module Executor
      extend POSIX::Spawn

      def self.sh(*args)
        r, w = IO.pipe
        e, eo = IO.pipe
        pid = spawn(*args, {
          :out => w, r => :close,
          :err => eo, e => :close
        })

        if pid > 0
          w.close
          eo.close
          out = r.read
          err = e.read
          ::Process.waitpid(pid)
          if out
            "#{out.to_s} #{err.to_s}".strip
          else
            nil
          end
        else
          nil
        end
      ensure
        [r, w, e, eo].each{ |io| io.close rescue nil }
      end
    end
  end
end
