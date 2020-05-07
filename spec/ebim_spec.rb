RSpec.describe Ebim, type: :aruba do
  before(:each) do
    cd expand_path(Dir.pwd + '/spec/playground')
    append_environment_variable 'AWS_ACCESS_KEY_ID', 'aws_access_key'
    append_environment_variable 'AWS_SECRET_ACCESS_KEY', 'aws_secret_key'
  end 

  it "has a version number" do
    expect(Ebim::VERSION).not_to be nil
  end

  describe Ebim::Runner, type: :aruba do
    describe "raises error if .ebextensions don't exist" do
      let (:command) { 'ebim non_existent deploy --staged --no-verify-ssl --timeout 30' }
      before(:each) { run_command command}
      before(:each) { stop_all_commands }

      it "raises an error" do
        expect(last_command_started.output).to match /.ebextensions not present/
      end
    end
  end

  describe Ebim::Runner, type: :aruba do
    test_environment = TestEnvironment.new
    before(:all) { test_environment.setup }
    after(:all) { test_environment.teardown }

    before(:each) { run_command command}
    before(:each) { stop_all_commands }

    describe "#run" do
      describe "with env exists" do
        let (:command) { 'ebim staging deploy --staged --no-verify-ssl --timeout 30' }

        it "executes successfully" do
          output = last_command_started.output
          puts output
          expect(output).to match /Firing: eb deploy --staged --no-verify-ssl --timeout 30/i
        end
      end

      describe "when config files with mentioned env do not exist" do
        let (:command) { 'ebim custom deploy --staged --no-verify-ssl --timeout 30' }

        it "throws an error" do
          expect(last_command_started.output).to match /no config files with env: custom present/i
        end
      end
    end
  end
end
