require 'ebim/eb'

class CommandEnvironment
  EB_FOLDERS = ['.ebextensions', '.elasticbeanstalk']
  def initialize(env:, ebextensions:)
    @env = env
    @ebextensions = ebextensions
    @files_created = []
  end

  def setup
    EB_FOLDERS.map { |folder| create_config_file_from_env folder }
    `git add .ebextensions .elasticbeanstalk`
    `git -c user.name='ebim user' -c user.email='test@ebim.dev' commit -m 'temp commit by ebim'`
  end

  def teardown
    `git reset HEAD~1`
    files_created.map { |file| FileUtils.rm(file) }
  end

  private

  def create_config_file_from_env(folder)
    Dir.entries(folder).filter do |file|
      file_env = file.split('.').last
      if  file_env == env
        new_file_name = File.basename(file, ".#{env}")
        new_file = File.new("#{folder}/#{new_file_name}", "w+")
        FileUtils.copy_file("#{folder}/#{file}", new_file)
        new_file.close
        files_created << new_file
      end
    end
  end

  def get_env_files
    Dir.entries
  end

  attr_reader :env, :ebextensions
  attr_accessor :files_created
end

