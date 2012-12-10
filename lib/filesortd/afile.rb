require "popen4"
require "fileutils"

module Filesortd
  class Afile < Struct.new(:path)

    def contents
      File.read path
    end

    def rm
      File.unlink path
    end
    alias :remove :rm
    alias :delete :rm
    alias :unlink :rm

    def cp(target)
      FileUtils.cp path, target
    end
    alias :copy :cp

    def mv(target)
      FileUtils.mv path, target
    end
    alias :move :mv

    def pipe(cmd)
      out = nil
      POpen4::popen4(cmd) do |stdout, stderr, stdin, pid|
        stdin.puts File.read(path)
        stdin.close
        out = stdout.read.strip
      end
      out
    end

    def pass(cmd)
      out = nil
      POpen4::popen4("#{cmd} #{path.shellescape}") do |stdout, stderr, stdin, pid|
        stdin.close
        out = stdout.read.strip
      end
      out
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
      system %{osascript -e 'tell app "Finder" to set label index of (POSIX file "#{path}" as alias) to #{idx}'}
    end
  end
end
