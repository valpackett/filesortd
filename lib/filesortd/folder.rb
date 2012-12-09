require "listen"
require "docile"
require "filesortd/callback"

module Filesortd
  def folder(*paths, &block)
    callback = Docile.dsl_eval(Callback.new, &block).build
    Listen.to(*paths).latency(0.1).change(&callback).start
  end
end
