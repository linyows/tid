module Tid
  module Boot2docker
    class << self
      def env_keys
        %w(
          DOCKER_HOST
          DOCKER_CERT_PATH
          DOCKER_TLS_VERIFY
        )
      end

      def env
        @env ||= env!
      end

      def env!
        out = `boot2docker shellinit 2>/dev/null`
        env_keys.each.with_object({}) do |key, memo|
          out.match(/#{key}=(.*)/)
          memo[key] = $1.chomp
        end
      end

      def prepare
        up unless running?
      end

      def status
        Console.cmd 'boot2docker status'
      end

      def have?
        !`which boot2docker`.empty?
      end

      def running?
        status == 'running'
      end

      def ip
        out, _, _ = Console.cmd 'boot2docker ip'
        out.to_s.chomp
      end

      def up
        Console.cmd 'boot2docker up'
      end
    end
  end
end
