require "shellwords"

module Filesortd
  # Basic matcher
  class Matcher < Struct.new(:pattern)
    def match(s)
      if pattern.is_a? Regexp
        !pattern.match(s).nil? # return a boolean through "not nil"
      elsif pattern.is_a? String
        File.fnmatch(pattern, s)
      end
    end
  end

  class BasenameMatcher < Matcher
    alias :super_match :match
    def match(path)
      super_match(File.basename(path))
    end
  end

  class XattrMatcher
    def initialize(xattr, &matcher)
      require "osx/plist"
      @xattr = xattr
      @matcher = matcher
    end

    def match(path)
      return false unless `xattr -l #{path.shellescape}`.include? @xattr
      str = [`xattr -px #{@xattr.shellescape} #{path.shellescape}`.gsub("\n", "").gsub(" ", "")].pack("H*")
      pl = OSX::PropertyList.load(str)
      @matcher.call(pl, path)
    end
  end

  class SpotlightMatcher
    def initialize(key, value)
      @key = key
      @matcher = Matcher.new(value)
    end

    def match(path)
      val = `mdls -raw -name #{@key} #{path.shellescape}`
      @matcher.match(val)
    end
  end

  class AlwaysTrueMatcher
    def match(s)
      true
    end
  end
end
