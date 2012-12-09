require "thor"
require "filesortd"

module Filesortd
  class Script
    include Filesortd
  end

  class CLI < Thor
    default_task :start

    desc 'start FILENAME', 'Start filesortd'
    def start(filename)
      puts 'Started filesortd'
      Script.new.instance_eval File.read(filename)
    end

    desc 'version', 'Show the Guard version'
    map %w(-v --version) => :version
    def version
      puts ::Filesortd::VERSION
    end
  end
end
