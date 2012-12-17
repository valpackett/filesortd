# Filesortd [![Build Status](https://travis-ci.org/myfreeweb/filesortd.png?branch=master)](https://travis-ci.org/myfreeweb/filesortd)

A Ruby DSL for automatically sorting your files based on rules.
Like [Hazel](http://www.noodlesoft.com/hazel.php), but cross-platform, no GUI required.

## Installation

    $ gem install filesortd

If you're on OS X, also install osx-plist for things like `downloaded_from` (i.e. xattr support) to work:

    $ gem install osx-plist

## Usage

    $ filesortd start yourconfig.rb

yourconfig.rb:

```ruby
# DSL usage example

folder "/Users/myfreeweb/Downloads" do

  # Do things to files that match a glob or a regex
  pattern "*.mp3" do
    mv "/Users/myfreeweb/Music"

    # Do things if running on a particular OS
    os :osx do
      label :orange
    end
  end

  # Mac OS X saves the location you downloaded a file from
  downloaded_from %r{destroyallsoftware} do
    mv "/Users/myfreeweb/Movies/DAS"
    open_in :default
    # or
    open_in "MPlayerX"
  end

  # Match on the kind, also OS X only
  kind "Ruby Source" do
    label :red
  end

  # Match all mp4 files downloaded from DAS
  match pattern: '*.mp4', downloaded_from: %r{destroyallsoftware} do
    label :gray
  end
end


# You can watch multiple folders at once

folders "/Users/myfreeweb/Pictures", "/opt/pictures" do

  # Do things to any files
  any do
    label :blue
  end

  pattern "*.png" do
    pass "optipng"
    label :green
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
- `open_in(app)` -- open the file using the OS X `open` command, use :default for the default app for the file type
