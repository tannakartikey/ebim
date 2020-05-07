require 'ebim'
require 'ebim/ebextensions'
require 'ebim/command_environment'

module Ebim
  class Runner
    class << self
      def run(args)
        if args.length < 1
          puts "Args not right"
          return false
        end
        new(args).run
      end
    end

    def initialize(args)
      @env = args.shift
      @args = args

      ebextensions = Ebextensions.new(env: env)
      ebextensions.exist?
      ebextensions.has_eb_config?
      ebextensions.has_ebextension_configs?
    end

    def run
      command_environment = CommandEnvironment.new(env: env)
      command_environment.setup
      execute_command
      command_environment.teardown
    end

    private
    
    def execute_command
      command = "eb #{serialized_args}"
      puts "[ENV: #{env}] Firing: #{command}"
      output = `#{command}`
      puts output
      # fork { exec(command) }
    end

    def serialized_args
      @_serialized_args ||= args.join(" ")
    end

    attr_accessor :env, :args
  end
end
