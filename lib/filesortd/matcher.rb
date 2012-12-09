module Filesortd
  class Matcher
    def self.match(pattern, path)
      filename = File.basename(path)
      if pattern.is_a? Regexp
        !pattern.match(filename).nil? # return a boolean through "not nil"
      elsif pattern.is_a? String
        File.fnmatch(pattern, filename)
      end
    end
  end
end
