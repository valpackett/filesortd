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

    def downloaded_from(pattern, &callback)
      pm = Matcher.new(pattern)
      m = XattrMatcher.new("com.apple.metadata:kMDItemWhereFroms") do |elements, path|
        elements.map { |el| pm.match(el) }.count(true) >= 1
      end
      @matchers[m] = callback
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
