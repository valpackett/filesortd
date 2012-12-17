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

  # Match on Finder label, OS X
  label :green do
    mv "/Users/myfreeweb/Documents"
  end

  # Match all mp4 files downloaded from DAS
  match pattern: '*.mp4', downloaded_from: %r{destroyallsoftware} do
    label :gray
  end

  # Match files either labelled gray or blue
  any({ label: :gray }, { label: :blue }) do
  end
end


# You can watch multiple folders at once
folders "/Users/myfreeweb/Pictures", "/opt/pictures" do
  # Do things to any files
  any do
    applescript 'tell app "Finder" to reveal theFile'
    label :blue
  end

  # Match by extension -- same as pattern "*.png"
  ext :png do
    pass "optipng"
    label :green
  end
end
```

### Matchers

- `any(matcher1,matcher2)` -- any file that passes either matcher1 or matcher2. If no matcher is specified, it's true
- `all(matcher1,matcher2)` -- any file that passes both matcher1 and matcher2
- `pattern(pat)` -- files that conform to `pat`
- `ext(extn)` (or `extension`) -- files that have an extension of `extn`
- `kind(knd)` -- files that have Spotlight kind of `knd`
- `label(lbl)` -- files that have Finder label of `lbl`
- `downloaded_from(url)` -- files that were downloaded from url
  `url`/url matching `url`

Matchers can be called either by themselves

```ruby
label :gray do
  kind 'Ruby Source' do
  end
end
```

or grouped into a single statement (preferred)

```ruby
match label: :gray, kind: 'Ruby Source' do
end
```

### Actions

- `contents` (or `read`) -- get the contents
- `rm` (or `remove`, `delete`, `unlink`) -- remove
- `trash` -- put to trash (OS X/Linux, Linux requires [trash-cli](https://github.com/andreafrancia/trash-cli))
- `cp` (or `copy`) -- copy
- `mv` (or `move`) -- move/rename
- `pipe(cmd)` -- start the command, pass the file to stdin, get the stdout
- `pass(cmd)` -- start the command, pass the path to the file as an argument, get the stdout
- `label(color)` -- set the OS X Finder label (:none, :orange, :red, :yellow, :blue, :purple, :green, :gray or :grey)
- `open_in(app)` -- open the file using the OS X `open` command, use :default for the default app for the file type
- `applescript(script)` -- run provided AppleScript. Use `theFile` inside it to refer to the file matched

## Contributors

- [myfreeweb](https://github.com/myfreeweb)
- [goshakkk](https://github.com/goshakkk)

## License

MIT.
