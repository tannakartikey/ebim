require 'open3'
require 'ebim'
require 'ebim/eb'
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

      @ebextensions = EB.new(env: env)
      @ebextensions.exist?
      @ebextensions.has_eb_config?
      @ebextensions.has_ebextension_configs?
    end

    def run
      command_environment = CommandEnvironment.new(env: env, ebextensions: @ebextensions)
      command_environment.setup
      execute_command
      command_environment.teardown
    end

    private

    def execute_command
      command = "eb #{serialized_args}"
      puts "[ENV: #{env}] Firing: #{command}"
      Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
        while line=stdout.gets do
          puts line
        end
        while line=stderr.gets do
          puts line
        end
      end
    end

    def serialized_args
      @_serialized_args ||= args.join(" ")
    end

    attr_accessor :env, :args
  end
end
