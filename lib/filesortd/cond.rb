module Filesortd
  def os(s, &block)
    if s == current_os
      block.call
    end
  end

  private
  def current_os
    case RbConfig::CONFIG['target_os']
    when /freebsd/i then :freebsd
    when /darwin(1.+)?$/i then :osx
    when /linux/i then :linux
    when /mswin|mingw/i then :windows
    else
      :unknown
    end
  end
end
