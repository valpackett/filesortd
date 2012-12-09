require "popen4"
require "fileutils"

module Filesortd
  class Afile < Struct.new(:path)

    def rm
      File.unlink path
    end
    alias :remove :rm
    alias :delete :rm
    alias :unlink :rm

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
  end
end
