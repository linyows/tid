module Tid
  module Docker
    class << self
      def prepare
        Boot2docker.prepare if Boot2docker.have?
        build
        run
        set_env
      end

      def bundle(options = [])
        default_options = ['--gemfile', "#{base_path}/Gemfile", '--quiet']
        Bundler.with_clean_env do
          Console.cmd "bundle install #{default_options.merge(options).join(' ')}"
        end
      end

      def build
        Console.cmd "docker build -t #{image_name} #{base_path}"
      end

      def run
        Console.cmd "docker run -d -P --name #{container_name} #{image_name}"
      end

      def set_env
        ENV['TID_HOSTNAME'] = "#{ip}"
        ENV['TID_PORT'] = "#{ssh_port}"
      end

      def clear
        Console.cmd "docker stop #{container_name}"
        Console.cmd "docker rm #{container_name}"
        Console.cmd "docker rmi #{image_name}"
      end

      def ip
        Boot2docker.have? ? Boot2docker.ip : 'localhost'
      end

      def image_name
        ENV['TID_IMAGE_NAME'] || 'sshd/test'
      end

      def ssh_port
        if `docker ps | grep #{container_name}`
          out, _, _ = Console.cmd("docker port #{container_name} 22")
          out.to_s.chomp.gsub('0.0.0.0:', '')
        end
      end

      def container_name
        ENV['TID_CONTAINER_NAME'] || 'test_sshd'
      end

      def base_path
        ENV['TID_BASE_PATH'] || './spec/misc'
      end
    end
  end
end
