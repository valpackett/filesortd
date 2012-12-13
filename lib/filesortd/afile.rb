require "popen4"
require "fileutils"
require "shellwords"

module Filesortd
  class Afile
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def contents
      File.read @path
    end
    alias :read :contents

    def rm
      File.unlink @path
      @path = nil
    end
    alias :remove :rm
    alias :delete :rm
    alias :unlink :rm

    def cp(target)
      FileUtils.cp @path, target
      @path = target
    end
    alias :copy :cp

    def mv(target)
      FileUtils.mv @path, target
      @path = target
    end
    alias :move :mv

    def pipe(cmd)
      out = nil
      POpen4::popen4(cmd) do |stdout, stderr, stdin, pid|
        stdin.puts File.read(@path)
        stdin.close
        out = stdout.read.strip
      end
      out
    end

    def pass(cmd)
      out = nil
      POpen4::popen4("#{cmd} #{@path.shellescape}") do |stdout, stderr, stdin, pid|
        stdin.close
        out = stdout.read.strip
      end
      out
    end

    def open_in(app)
      if app == :default
        pass "open"
      else
        pass "open -a #{app.shellescape}"
      end
    end

    def label(lbl)
      if lbl.is_a? Symbol
        idx = {
          :none => 0,
          :orange => 1,
          :red => 2,
          :yellow => 3,
          :blue => 4,
          :purple => 5,
          :green => 6,
          :gray => 7,
          :grey => 7
        }[lbl]
      else
        idx = lbl
      end
      system %{osascript -e 'tell app "Finder" to set label index of (POSIX file "#{@path}" as alias) to #{idx}' 2&>/dev/null}
    end
  end
end
