require 'open3'
require 'rainbow/ext/string'

module Tid
  module Console
    class << self
      def default_env
        env = if DockerMachine.exists?
            DockerMachine.env
          else
            {}
          end
        env.merge!(Tid.env) unless Tid.env.nil?
        env
      end

      def cmd(str, env = {})
        env = default_env.merge(env)
        show_cmd(str, env) if debug?
        out, err, status = Open3.capture3(env, str)
        show_cmd_result(out, err, status) if debug?
        return out, err, status
      end

      def debug?
        !!ENV['DEBUG']
      end

      def show_cmd(str, env)
        puts "\n  # #{str}".color(:blue)
        env.each { |k,v| puts "    ENV['#{k}'] = #{v}" }
      end

      def show_cmd_result(out, err, status)
        puts "#{out}".chomp.gsub(/^(.*)/, '    \1').color(:green) unless out.empty?
        puts "#{err}".chomp.gsub(/^(.*)/, '    \1').color(:red) unless err.empty?
        puts "    exit status: #{status.exitstatus}".color(:yellow)
      end
    end
  end
end
