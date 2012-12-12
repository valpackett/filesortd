require "filesortd/matcher"
require "filesortd/afile"
require "docile"

module Filesortd
  class Callback
    attr_accessor :matchers

    def initialize
      @matchers = {}
    end

    def match(pattern, &callback)
      @matchers[Matcher.new(pattern)] = callback
    end

    def call(paths)
      paths.each do |path|
        @matchers.each do |matcher, callback|
          Docile.dsl_eval(Afile.new(path), &callback) if matcher.match(path)
        end
      end
    end

  end
end
