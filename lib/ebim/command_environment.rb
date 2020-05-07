class CommandEnvironment
  def initialize(env:)
    env = @env
  end

  def setup
    File.rename('.elasticbeanstalk/config.yml.staging', '.elasticbeanstalk/config.yml')
  end

  def teardown
    File.rename('.elasticbeanstalk/config.yml', '.elasticbeanstalk/config.yml.staging')
  end

  private

  attr_reader :env
end

