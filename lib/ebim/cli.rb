require "ebim/runner"
require "thor"

module Ebim
  class CLI
    def self.start(args)
      begin
        Runner.run(args)
      rescue => err
        puts err.message
      end
    end
  end
end
