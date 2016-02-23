module Tid
  module Docker
    class << self
      def build
        Console.cmd "docker build -t #{image_name} #{Tid.base_path}"
      end

      def run
        Console.cmd "docker run -d -P --name #{container_name} #{image_name}"
      end

      def stop
        Console.cmd "docker stop #{container_name}"
      end

      def rm
        Console.cmd "docker rm #{container_name}"
      end

      def rmi
        Console.cmd "docker rmi #{image_name}"
      end

      def hostname
        DockerMachine.exists? ? DockerMachine.ip : 'localhost'
      end

      def image_name
        ENV['TID_IMAGE_NAME'] || 'tid'
      end

      def container_ssh_port
        _, _, ex = Console.cmd "docker ps | grep #{container_name}"
        if ex.exitstatus.zero?
          out, _, _ = Console.cmd("docker port #{container_name} 22")
          out.to_s.chomp.gsub('0.0.0.0:', '')
        end
      end

      def container_name
        ENV['TID_CONTAINER_NAME'] || 'tid'
      end
    end
  end
end
