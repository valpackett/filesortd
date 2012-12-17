require "listen"
require "docile"
require "filesortd/callback"

module Filesortd
  def select_existing(paths)
    paths.select do |path|
      e = File.exists? path
      puts "Folder does not exist: #{path}" unless e
      e
    end
  end

  def folders(*paths, &block)
    paths = select_existing paths.map { |path| File.expand_path path }
    unless paths == []
      callback = Docile.dsl_eval(Callback.new, &block)
      cb = Proc.new do |modified, added, removed|
        puts "Processing files: #{added}"
        callback.call added
      end
      l = Listen.to(*paths).latency(0.5).change(&cb)
      l.start(false)
      @listeners << l
    end
  end
  alias :folder :folders
end
