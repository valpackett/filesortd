source 'https://rubygems.org'

# Specify your gem's dependencies in filesortd.gemspec
gemspec

gem 'rb-kqueue', '~> 0.2' if RbConfig::CONFIG['target_os'] =~ /freebsd/i
gem 'rb-fsevent', '~> 0.9.1' if RbConfig::CONFIG['target_os'] =~ /darwin(1.+)?$/i
gem 'rb-inotify', '~> 0.8.8', :github => 'mbj/rb-inotify' if RbConfig::CONFIG['target_os'] =~ /linux/i
gem 'wdm',        '~> 0.0.3' if RbConfig::CONFIG['target_os'] =~ /mswin|mingw/i

if RbConfig::CONFIG['target_os'] =~ /darwin(1.+)?$/i
  gem 'osx-plist'
end

group :development, :test do
  gem 'rake'
  gem 'rspec'
  gem 'cucumber'
  gem 'fuubar'
end
