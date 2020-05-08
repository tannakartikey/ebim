require_relative 'lib/ebim/version'

Gem::Specification.new do |spec|
  spec.name          = "ebim"

  spec.description   = <<-eos
    AWS Elatic Beanstalk CLI, awsebcli, does not provide option to set environment specific conviguration.
    For example, if you want to set different env variables on AWS EB using .ebextensions it is not supported. This wrapper makes it possible!
  eos

  spec.email         = ["tannakartikey@gmail.com"]
  spec.authors       = ["Kartikey Tanna"]
  spec.homepage      = "https://github.com/tannakartikey/ebim"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/tannakartikey/ebim"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.summary       = "AWS Elastic Beanstalk wrapper for environment speicific deplyoment from the same branch using .ebextensions!"
  spec.version       = Ebim::VERSION

  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "aruba"
  spec.add_development_dependency "pry"
end
