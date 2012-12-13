require "filesortd/matcher"
include Filesortd

describe BasenameMatcher do
  it "matches regexps on filenames" do
    BasenameMatcher.new(%r{hello-[0-9]+.mp3}).match("/Some/Folder/hello-123.mp3").should be_true
    BasenameMatcher.new(%r{hello-[0-9]+.mp3}).match("/Some/Folder/321-goodbye.mp3").should be_false
  end

  it "matches globs on filenames" do
    BasenameMatcher.new("*.jpg").match("/Some/Folder/pic.jpg").should be_true
    BasenameMatcher.new("*.jpg").match("/Some/Folder/pic.png").should be_false
  end
end

if RbConfig::CONFIG['target_os'] =~ /darwin(1.+)?$/i
  describe XattrMatcher do
    let(:path) { "/tmp/xattrtest" }
    let(:prop) { "com.apple.metadata:kMDItemWhereFroms" }
    let(:downloaded_das) { "62 70 6C 69 73 74 30 30 A2 01 02 5F 10 B5 68 74\n74 70 73 3A 2F 2F 73 33 2E 61 6D 61 7A 6F 6E 61\n77 73 2E 63 6F 6D 2F 64 65 73 74 72 6F 79 61 6C\n6C 73 6F 66 74 77 61 72 65 2F 64 61 73 2D 30 30\n31 34 2D 65 78 74 72 61 63 74 69 6E 67 2D 6F 62\n6A 65 63 74 73 2D 69 6E 2D 64 6A 61 6E 67 6F 2E\n6D 6F 76 3F 41 57 53 41 63 63 65 73 73 4B 65 79\n49 64 3D 41 4B 49 41 49 4B 52 56 43 45 43 58 42\n43 34 5A 47 48 49 51 26 45 78 70 69 72 65 73 3D\n31 33 35 35 33 32 35 35 31 33 26 53 69 67 6E 61\n74 75 72 65 3D 64 6C 4D 48 52 6D 73 78 64 56 70\n45 6F 4B 58 44 62 50 38 59 6F 65 36 51 37 44 77\n25 33 44 5F 10 36 68 74 74 70 73 3A 2F 2F 77 77\n77 2E 64 65 73 74 72 6F 79 61 6C 6C 73 6F 66 74\n77 61 72 65 2E 63 6F 6D 2F 73 63 72 65 65 6E 63\n61 73 74 73 2F 63 61 74 61 6C 6F 67 08 0B C3 00\n00 00 00 00 00 01 01 00 00 00 00 00 00 00 03 00\n00 00 00 00 00 00 00 00 00 00 00 00 00 00 FC" }

    before { File.write  path, "123" }
    after  { File.unlink path }

    it "returns true for matched xattrs" do
      system "xattr -wx #{prop.shellescape} '#{downloaded_das}' #{path.shellescape}"
      m = XattrMatcher.new(prop) do |elements, path|
        elements.map { |el| !(el =~ %r{destroyallsoftware}).nil? }.count(true) >= 1
      end
      m.match(path).should be_true
    end

    it "returns false for invalid xattrs" do
      system "xattr -wx #{prop.shellescape} '#{downloaded_das}' #{path.shellescape}"
      m = XattrMatcher.new(prop) do |elements, path|
        elements.map { |el| !(el =~ %r{destroyNOsoftware}).nil? }.count(true) >= 1
      end
      m.match(path).should be_false
    end

    it "returns false for no xattrs" do
      m = XattrMatcher.new(prop) do |elements, path|
        elements.map { |el| !(el =~ %r{destroyallsoftware}).nil? }.count(true) >= 1
      end
      m.match(path).should be_false
    end

  end

  describe SpotlightMatcher do
    it "matches spotlight attributes" do
      path = "/tmp/spotlighttest.rb"
      File.write path, "puts 'hello'"
      SpotlightMatcher.new("kMDItemKind", "Ruby Source").match(path).should be_true
      SpotlightMatcher.new("kMDItemKind", "Perl Source").match(path).should be_false
    end
  end
end
