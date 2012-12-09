require "filesortd/matcher"
require "filesortd/afile"
require "docile"

module Filesortd
  class Callback
    def initialize
      @patterns = {}
    end

    def match(pattern, &callback)
      @patterns[pattern] = callback
    end

    def build
      Proc.new do |modified, added, removed|
        puts "Processing files: #{added}"
        added.each do |path|
          @patterns.each do |pattern, callback|
            Docile.dsl_eval(Afile.new(path), &callback) if Matcher.match(pattern, path)
          end
        end
      end
    end
  end
end
