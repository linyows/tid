module Tocker
  module Docker
    class << self
      def prepare
        bundle
        Boot2docker.prepare if Boot2docker.have?
        build
        run
        set_env
      end

      def bundle
        Bundler.with_clean_env do
          CommandHelper.cmd 'bundle install --gemfile ./spec/misc/Gemfile --quiet'
        end
      end

      def build
        CommandHelper.cmd "docker build -t #{image_name} ./spec/misc"
      end

      def run
        CommandHelper.cmd "docker run -d -P --name #{container_name} #{image_name}"
      end

      def set_env
        ENV['TEST_HOSTNAME'] = "#{ip}"
        ENV['TEST_PORT'] = "#{ssh_port}"
      end

      def clear
        CommandHelper.cmd "docker stop #{container_name}"
        CommandHelper.cmd "docker rm #{container_name}"
        CommandHelper.cmd "docker rmi #{image_name}"
      end

      def ip
        Boot2docker.have? ? Boot2docker.ip : 'localhost'
      end

      def image_name
        ENV['TOCKER_IMAGE_NAME'] || 'sshd/test'
      end

      def ssh_port
        if `docker ps | grep #{container_name}`
          out, _, _ = CommandHelper.cmd("docker port #{container_name} 22")
          out.to_s.chomp.gsub('0.0.0.0:', '')
        end
      end

      def container_name
        ENV['TOCKER_CONTAINER_NAME'] || 'test_sshd'
      end
    end
  end
end
