module Tid
  module Boot2docker
    class << self
      def env
        {
          'DOCKER_HOST' => Boot2docker.docker_host,
          'DOCKER_CERT_PATH' => Boot2docker.docker_cert_path,
          'DOCKER_TLS_VERIFY' => Boot2docker.docker_tls_verify
        }
      end

      def prepare
        Boot2docker.up unless running?
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

      def docker_host
        `echo $DOCKER_HOST`.chomp
      end

      def docker_cert_path
        `echo $DOCKER_CERT_PATH`.chomp
      end

      def docker_tls_verify
        `echo $DOCKER_TLS_VERIFY`.chomp
      end

      def up
        Console.cmd 'boot2docker up'
        shellinit
      end

      def shellinit
        Console.cmd '$(boot2docker shellinit)'
      end
    end
  end
end
