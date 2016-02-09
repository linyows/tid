module Tid
  module DockerMachine
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

      def machine_name
        ENV['DOCKER_MACHINE_NAME'] ||= 'dev'
      end

      def env!
        out = `docker-machine env #{machine_name}`
        env_keys.each.with_object({}) do |key, memo|
          out.match(/#{key}=(.*)/)
          memo[key] = $1.chomp
        end
      end

      def prepare
        up unless running?
      end

      def status
        Console.cmd "docker-machine status #{machine_name}"
      end

      def exists?
        !`which docker-machine`.empty?
      end

      def running?
        status.downcase == 'running'
      end

      def ip
        out, _, _ = Console.cmd "docker-machine ip #{machine_name}"
        out.to_s.chomp
      end

      def up
        Console.cmd "docker-machine create -d virtualbox #{machine_name}"
      end
    end
  end
end
