require 'ebim'

module Ebim
  class Deploy
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
      ebextensions_exist?

      @files = list_files
      @env = args.shift
      @args = args

      check_files_for_env
    end

    def run
      command = "eb #{serialized_args}"
      puts "[ENV: #{env}] Firing: #{command}"
      exec(command)
    end

    private

    def serialized_args
      @_serialized_args ||= args.join(" ")
    end

    def ebextensions_exist?
      raise Ebim::Error.new( ".ebextensions not present") unless Dir.exist?('.ebextensions')
    end

    def check_files_for_env
      raise Ebim::Error.new( "No config files with env: #{env} present!") unless config_files_with_env_present? 
    end

    def config_files_with_env_present?
      files.map { |file| file.split('.').last }.include? env
    end

    def list_files
      Dir.entries(".ebextensions")
    end

    attr_accessor :files, :env, :args
  end
end
