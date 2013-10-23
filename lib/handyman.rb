require "handyman/version"
require 'net/ssh'
require 'yaml'

module Handyman
  class << self

    # Build the instruction set to execute on the remote box
    def make(blueprint, host, user, password)
      blueprint = Blueprint.new(host, user, password)
      blueprint.build
      blueprint.execute
    end

  end

  class Blueprint
    attr_accessor :ssh, :run_list, :config_file, :opts

    def initialize(host, user, password)
      @ssh = Net::SSH.start(host, user, password: password)
      @run_list = []
      @config_file = 'lib/config.yml'
      @opts = {
        email: 'test@test.com'
        name: 'John Doe'
      }
    end
  
    def build
      configuration_instructions.each do |instruction|
        @run_list << { instruction[0] => instruction[1] }
      end
    end
  
    def configuration_instructions
      YAML.load interpolated_config
    end
  
    def interpolated_config
       File.open(@config_file,'r').each_line.reduce(''){ |str, line|
         str << line % opts
       }
    end
  
    def execute
      @run_list.each do |instruction|
        instruction.each_pair do |title, commands|
          puts title
          commands.to_a.each{ |command| ssh.exec! command }
        end
      end
    end

  end
end
