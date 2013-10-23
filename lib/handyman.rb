require "handyman/version"
require 'net/ssh'
require 'yaml'

module Handyman
  class << self

    # Build the instruction set to execute on the remote box
    def build(blueprint, branch='default')
      # Load in the instruction set to send
      instructions = parse(blueprint, branch)
      
    end

    # Parse the Blueprint file
    def parse(blueprint, branch)
      YAML.load_file blueprint
      if branch == 'default'
        # Parse the entire thing
      else
        # They must want something specific, find it
      end
    end

  end
  
    class Blueprint
    attr_accessor :ssh, :run_list, :config_file, :opts

    def initialize(host, user, password)
      @ssh = Net::SSH.start(host, user, password: password)
      @run_list = []
      @config_file = 'lib/config.yml'
      @opts = {
        name: host,
        dir: '/var/www',
        current_branch: 'master'
      }
    end

    def pretty_runlist
      @run_list.each do |instruction|
        instruction.each_pair do |title, commands|
          puts title
          commands.to_a.each{ |command| puts "  #{command}" }
          puts
        end
      end
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
