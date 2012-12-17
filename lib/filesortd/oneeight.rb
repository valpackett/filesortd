if RUBY_VERSION =~ /1.8/
  class File
    def self.write(path, content)
      f = File.new(path, "w")
      f.write(content)
      f.close
    end
  end
end
