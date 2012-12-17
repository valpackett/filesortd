require "filesortd/matcher"
require "filesortd/afile"
require "docile"

module Filesortd
  # Folder DSL (add matchers)
  class Callback
    # For some reason, label indices are opposite when setting/getting via
    # AppleScript vs mdls
    FINDER_LABELS = {
      :none => 0,
      :orange => 7,
      :red => 6,
      :yellow => 5,
      :blue => 4,
      :purple => 3,
      :green => 2,
      :gray => 1,
      :grey => 1
    }

    attr_accessor :matcher_sets

    def initialize
      @matcher_sets = {}
    end

    def match(options={}, &callback)
      @matcher_sets[matcher(options)] = callback
    end

    def any(*matchers, &callback)
      match :any => matchers, &callback
    end

    def all(*matchers, &callback)
      match :all => matchers, &callback
    end

    def pattern(pattern, &callback)
      match :pattern => pattern, &callback
    end

    def extension(ext, &callback)
      match :extension => ext, &callback
    end
    alias :ext :extension

    def kind(pattern, &callback)
      match :kind => pattern, &callback
    end

    def label(lbl, &callback)
      match :label => lbl, &callback
    end

    def downloaded_from(pattern, &callback)
      match :downloaded_from => pattern, &callback
    end

    def call(paths)
      paths.each do |path|
        @matcher_sets.each do |matchers, callback|
          Docile.dsl_eval(Afile.new(path), &callback) if matchers.match(path)
        end
      end
    end

    private
    def matcher(type, pattern=nil)
      case type
      when Hash
        AndMatcher.new type.map { |matchr, params| matcher(matchr.to_sym, params) }
      when Array
        AndMatcher.new type
      when Matcher
        type
      when :all, :any
        klass = type == :all ? AndMatcher : OrMatcher
        matchers = pattern.map { |m| matcher(m) }
        klass.new matchers
      when :any
        AlwaysTrueMatcher.new
      when :pattern
        BasenameMatcher.new pattern
      when :extension, :ext
        BasenameMatcher.new "*.#{pattern}"
      when :kind
        SpotlightMatcher.new "kMDItemKind", pattern
      when :label
        if pattern.is_a? Symbol
          idx = FINDER_LABELS[pattern]
        else
          idx = pattern
        end
        SpotlightMatcher.new "kMDItemFSLabel", idx
      when :downloaded_from
        pm = Matcher.new(pattern)
        m = XattrMatcher.new("com.apple.metadata:kMDItemWhereFroms") do |elements, path|
          elements.map { |el| pm.match(el) }.count(true) >= 1
        end
      end
    end
  end
end
