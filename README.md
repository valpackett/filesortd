# Filesortd

A Ruby DSL for automatically sorting your files based on rules.
Like [Hazel](http://www.noodlesoft.com/hazel.php), but cross-platform, no GUI required.

## Installation

    $ gem install filesortd

## Usage

    $ filesortd start yourconfig.rb

yourconfig.rb:

```ruby
folder "/Users/myfreeweb/Downloads" do
  match "*.mp3" do
    mv "/Users/myfreeweb/Music"
    on :osx do
      label :orange
    end
  end
end

folder "/Users/myfreeweb/Pictures" do
  match "*.png" do
    pass "optipng" # pass -- execute a command with the path as an argument
  end
end
```
