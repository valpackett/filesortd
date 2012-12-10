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
  # Do things to files that match a glob or a regex
  match "*.mp3" do
    mv "/Users/myfreeweb/Music"

    # Do things if running on a particular OS
    on :osx do
      label :orange
    end
  end
end

folder "/Users/myfreeweb/Pictures" do
  match "*.png" do
    pass "optipng"
    # pass -- execute a command with the path as an argument
  end
end
```

Actions:

- `contents` (or `read`) -- get the contents
- `rm` (or `remove`, `delete`, `unlink`) -- remove
- `cp` (or `copy`) -- copy
- `mv` (or `move`) -- move/rename
- `pipe(cmd)` -- start the command, pass the file to stdin, get the stdout
- `pass(cmd)` -- start the command, pass the path to the file as an argument, get the stdout
- `label(color)` -- set the OS X Finder label (:none, :orange, :red, :yellow, :blue, :purple, :green, :gray or :grey)
