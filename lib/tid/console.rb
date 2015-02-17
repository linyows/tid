require 'open3'
require 'rainbow/ext/string'

module Tid
  module Console
    class << self
      def default_env
        @default_env ||= if Boot2docker.have?
          Boot2docker.env
        else
          {}
        end
      end

      def cmd(str, env = {})
        env = default_env.merge(env)
        out, err, status = Open3.capture3(env, str)
        show_debuggings(str, env, out, err, status) if debug?
        return out, err, status
      end

      def debug?
        !!ENV['DEBUG']
      end

      def show_debuggings(str, env, out, err, status)
        puts "  $ #{str} (exit: #{status.exitstatus})".color(:blue)
        puts "#{out}".gsub(/^(.*)/, '    \1').color(:green) unless out.empty?
        puts "#{err}".gsub(/^(.*)/, '    \1').color(:red) unless err.empty?
      end
    end
  end
end
