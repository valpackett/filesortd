require "filesortd/matcher"
include Filesortd

describe Matcher do
  it "matches regexps on filenames" do
    Matcher.new(%r{hello-[0-9]+.mp3}).match("/Some/Folder/hello-123.mp3").should be_true
    Matcher.new(%r{hello-[0-9]+.mp3}).match("/Some/Folder/321-goodbye.mp3").should be_false
  end

  it "matches globs on filenames" do
    Matcher.new("*.jpg").match("/Some/Folder/pic.jpg").should be_true
    Matcher.new("*.jpg").match("/Some/Folder/pic.png").should be_false
  end
end
