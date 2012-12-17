require "filesortd/matcher"
require "filesortd/afile"
require "docile"

module Filesortd
  class Callback
    attr_accessor :matchers

    def initialize
      @matchers = {}
    end

    def any(&callback)
      @matchers[matcher(:any)] = callback
    end

    # Public: Match the file based on a set of other matchers.
    #
    # pattern - The optional String pattern to match file by.
    # options - The optional Hash of matcher -> params pairs:
    #           :basename        - The String pattern to match by.
    #           Alternatively, can be passed as the `pattern` argument.
    #           :kind            - The String `kMDItemKind` to match by.
    #           :downloaded_from - The Regexp to match downloaded_from
    #           URL by.
    #
    # Examples
    #
    #   match '*.png'
    #   # Matches only PNG image files.
    #
    #   match downloaded_from: %{destroyallsoftware}
    #   # Matches only items that were downloaded from URL satisfying
    #   the regexp.
    #
    #   match '*.mp4', downloaded_from: %r{destroyallsoftware}
    #   # The combination of both basename and xattr matchers.
    #
    #   match basename: '*.mp4', downloaded_from: %{destroyallsoftware}
    #   # Same as previous, but passing basename pattern in options
    #   hash.
    def match(pattern, options = {}, &callback)
      case pattern
      when String
        match options.merge(:basename => pattern), &callback
      else
        options = pattern
        
        matchers = options.map { |matchr, params| matcher(matchr.to_sym, params) }

        @matchers[matchers] = callback
      end
    end

    def basename(pattern, &callback)
      @matchers[matcher(:basename, pattern)] = callback
    end

    def kind(pattern, &callback)
      @matchers[matcher(:kind, pattern)] = callback
    end

    def downloaded_from(pattern, &callback)
      @matchers[matcher(:downloaded_from, pattern)] = callback
    end

    def call(paths)
      puts 'processing...'
      paths.each do |path|
        @matchers.each do |matchers, callback|
          # If matcher is an array already, it won't be changed
          # And if it's a single matcher, it'll be wrapped into an array
          matchers = [matchers].flatten
          Docile.dsl_eval(Afile.new(path), &callback) if matchers.all? { |m| m.match(path) }
        end
      end
    end

    # Internal: Create a matcher instance, given its type and options to
    # pass to it.
    def matcher(type, pattern = nil)
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
