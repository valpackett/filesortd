require "filesortd/matcher"
require "filesortd/afile"
require "docile"

module Filesortd
  # Folder DSL (add matchers)
  class Callback
    attr_accessor :matcher_sets

    def initialize
      @matcher_sets = {}
    end

    def match(options={}, &callback)
      matchers = options.map { |matchr, params| matcher(matchr.to_sym, params) }
      @matcher_sets[matchers] = callback
    end

    def any(&callback)
      match(:any, &callback)
    end

    def pattern(pattern, &callback)
      match(:basename, &callback)
    end

    def kind(pattern, &callback)
      match(:kind, &callback)
    end

    def downloaded_from(pattern, &callback)
      match(:downloaded_from, &callback)
    end

    def call(paths)
      paths.each do |path|
        @matcher_sets.each do |matchers, callback|
          # If matcher is an array already, it won't be changed
          # And if it's a single matcher, it'll be wrapped into an array
          matchers = [matchers].flatten
          Docile.dsl_eval(Afile.new(path), &callback) if matchers.all? { |m| m.match(path) }
        end
      end
    end

    private
    def matcher(type, pattern=nil)
      case type
      when :any
        AlwaysTrueMatcher.new
      when :basename
        BasenameMatcher.new pattern
      when :kind
        SpotlightMatcher.new "kMDItemKind", pattern
      when :downloaded_from
        pm = Matcher.new(pattern)
        m = XattrMatcher.new("com.apple.metadata:kMDItemWhereFroms") do |elements, path|
          elements.map { |el| pm.match(el) }.count(true) >= 1
        end
      end
    end
  end
end
