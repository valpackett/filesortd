require "listen"
require "docile"
require "filesortd/callback"

module Filesortd
  def folders(*paths, &block)
    callback = Docile.dsl_eval(Callback.new, &block)
    cb = Proc.new do |modified, added, removed|
      puts "Processing files: #{added}"
      callback.call added
    end
    l = Listen.to(*paths).latency(0.5).change(&cb)
    l.start(false)
    @listeners << l
  end
  alias :folder :folders
end
