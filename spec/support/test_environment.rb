require 'fileutils'

class TestEnvironment

  def initialize
    @playground_path = Dir.pwd + '/spec/playground/'
    Dir.mkdir(@playground_path) unless Dir.exist?(@playground_path)

    @ebextensions_path = Dir.pwd + '/spec/playground/.ebextensions'
    @elasticbeanstalk_path = Dir.pwd + '/spec/playground/.elasticbeanstalk'
  end

  def setup
    create_ebconfig
    create_ebextensions
    git_init
  end

  def teardown
    delete_ebconfig
    delete_ebextensions
    delete_playground
  end

  private

  def git_init
    `git init spec/playground`
    `cd spec/playground && git add .ebextensions .elasticbeanstalk && cd -`
    `cd spec/playground && git commit -m "Initial Commit" && cd -`
  end

  def create_ebconfig
    Dir.mkdir(elasticbeanstalk_path) unless Dir.exist?(ebextensions_path)
    config_file = File.open("#{elasticbeanstalk_path}/config.yml.staging", "w+")
    content = <<-EOF
      branch-defaults:
        master:
          environment: env-one-name
        master:
          environment: env-two-name
        group_suffix: null
      global:
        application_name: application_name
        branch: null
        default_ec2_keyname: aws-eb
        default_platform: Ruby 2.6 (Puma)
        default_region: ca-central-1
        include_git_submodules: true
        instance_profile: null
        platform_name: null
        platform_version: null
        profile: null
        repository: null
        sc: git
        workspace_type: Application
    EOF
    config_file << content
    config_file.close
  end

  def create_ebextensions
    Dir.mkdir(ebextensions_path) unless Dir.exist?(ebextensions_path)
    File.new("#{ebextensions_path}/00_packages.config", File::CREAT)
    File.new("#{ebextensions_path}/01_env.config.staging", File::CREAT)
    File.new("#{ebextensions_path}/01_env.config.production", File::CREAT)
    File.new("#{ebextensions_path}/03_create_sidekiq_logs.config", File::CREAT)
    File.new("#{ebextensions_path}/04_sidekiq_worker.config", File::CREAT)
    File.new("#{ebextensions_path}/05_sidekiq_upstart.config", File::CREAT)
    File.new("#{ebextensions_path}/06_sidekiq_mute.config", File::CREAT)
    File.new("#{ebextensions_path}/07_sidekiq_restart.config", File::CREAT)
    File.new("#{ebextensions_path}/08_sidekiq_hooks.config", File::CREAT)
    File.new("#{ebextensions_path}/99_wkhtmltopdf.config", File::CREAT)
  end

  def delete_ebconfig
    FileUtils.rm_r(ebextensions_path)
  end

  def delete_ebextensions
    FileUtils.rm_r(elasticbeanstalk_path)
  end

  def delete_playground
    FileUtils.rm_r(@playground_path, force: true)
  end

  attr_reader :ebextensions_path, :elasticbeanstalk_path, :playground_path, :repo
end
