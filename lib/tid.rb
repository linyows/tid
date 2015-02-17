require 'tid/version'
require 'tid/boot2docker'
require 'tid/docker'
require 'tid/console'

module Tid
  def cmd(str, env = {})
    Console.cmd(str, env)
  end
end
