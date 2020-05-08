require 'ebim'

class EB
  EB_FOLDERS = ['.ebextensions', '.elasticbeanstalk']
  def initialize(env:)
    @env = env
  end

  def exist?
    EB_FOLDERS.map { |folder| folder_exists? folder }
  end

  def has_ebextension_configs?
    raise Ebim::Error.new( "No config files with env: #{env} present!") unless files_with_env_present?(ebextension_configs)
  end

  def has_eb_config?
    raise Ebim::Error.new( "No config files with env: #{env} present!") unless files_with_env_present?(eb_config)
  end

  def get_config_files
    all_config_files.select { |file| file.split('.').last == env }
  end

  private

  def all_config_files
    EB_FOLDERS.map { |folder| Dir.entries(folder) }.flatten
  end

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
