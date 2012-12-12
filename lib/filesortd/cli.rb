require "thor"
require "filesortd"

module Filesortd
  class Script
    include Filesortd
    attr_accessor :listeners
    def initialize
      @listeners = []
    end
  end

  class CLI < Thor
    default_task :start

    desc 'start FILENAME', 'Start filesortd'
    def start(filename)
      puts 'Started filesortd'
      begin
        scpt = Script.new
        scpt.instance_eval File.read(filename)
        loop { sleep 0.1 }
        # sleep to prevent 100% cpu load
      rescue Interrupt
        scpt.listeners.each do |l|
          l.stop
        end
        puts 'Stopped filesortd'
      end
    end

    desc 'version', 'Show the Guard version'
    map %w(-v --version) => :version
    def version
      puts ::Filesortd::VERSION
    end
  end
end
