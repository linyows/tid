require 'tid/version'
require 'tid/boot2docker'
require 'tid/docker'
require 'tid/console'

module Tid
  def cmd(str, env = {})
    Console.cmd(str, env)
  end

  class << self
    def prepare
      Boot2docker.prepare if Boot2docker.have?
      Docker.build
      Docker.run
      self.env!
    end

    def clear
      Docker.stop
      Docker.rm
      Docker.rmi
    end

    def bundle(options = [])
      default_options = [
        '--gemfile',
        "#{base_path}/Gemfile"
      ]

      Bundler.with_clean_env do
        Console.cmd "bundle install #{default_options.concat(options).join(' ')}"
      end
    end

    def base_path
      ENV['TID_BASE_PATH'] ||= './spec/tid'
    end

    def env
      @env
    end

    def env!
      ENV['TID_HOSTNAME'] = h = Docker.hostname
      ENV['TID_PORT'] = p = Docker.container_ssh_port

      @env = {
        'TID_HOSTNAME' => h,
        'TID_PORT' => p,
        'TID_BASE_PATH' => base_path
      }
    end
  end
end
