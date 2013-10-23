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
end
