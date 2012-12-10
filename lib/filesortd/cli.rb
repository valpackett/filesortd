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
        loop {}
      rescue Interrupt
        scpt.listeners.each do |l|
          l.stop
        end
      end
    end

    desc 'version', 'Show the Guard version'
    map %w(-v --version) => :version
    def version
      puts ::Filesortd::VERSION
    end
  end
end
