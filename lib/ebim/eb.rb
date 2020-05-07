require 'ebim'

class EB
  def initialize(env:)
    @env = env
  end

  def exist?
    ['.ebextensions', '.elasticbeanstalk'].map { |folder| folder_exists? folder }
  end

  def has_ebextension_configs?
    raise Ebim::Error.new( "No config files with env: #{env} present!") unless files_with_env_present?(ebextension_configs)
  end

  def has_eb_config?
    raise Ebim::Error.new( "No config files with env: #{env} present!") unless files_with_env_present?(eb_config)
  end

  private

  def ebextension_configs
    @ebextension_configs ||= list_files(".ebextensions")
  end

  def eb_config
    @_eb_config ||= list_files(".elasticbeanstalk")
  end

  def list_files dir
    Dir.entries(dir)
  end

  def files_with_env_present?(files)
    files.map { |file| file.split('.').last }.include? env
  end

  def folder_exists? folder
    raise Ebim::Error.new("#{folder} not present") unless Dir.exist?(folder)
  end

  attr_accessor :env, :args
end
