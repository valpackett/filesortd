require "filesortd/matcher"
include Filesortd

describe Matcher do
  it "matches regexps on filenames" do
    Matcher.match(%r{hello-[0-9]+.mp3}, "/Some/Folder/hello-123.mp3").should be_true
    Matcher.match(%r{hello-[0-9]+.mp3}, "/Some/Folder/321-goodbye.mp3").should be_false
  end

  it "matches globs on filenames" do
    Matcher.match("*.jpg", "/Some/Folder/pic.jpg").should be_true
    Matcher.match("*.jpg", "/Some/Folder/pic.png").should be_false
  end
end
