require "filesortd/afile"
include Filesortd

if RUBY_VERSION =~ /1.8/
  class File
    def self.write(path, content)
      f = File.new(path, "w")
      f.write(content)
      f.close
    end
  end
end

describe Afile do
  let(:path) { "/tmp/filesortdtest" }

  it "shows contents" do
    File.write path, "1"
    Afile.new(path).contents.should == "1"
    File.unlink path
  end

  it "copies" do
    path2 = "/tmp/filesortdtest2"
    File.write path, "1"
    af = Afile.new(path)
    af.cp path2
    af.path.should == path2
    File.exists?(path).should be_true
    File.exists?(path2).should be_true
    File.unlink path
    File.unlink path2
  end

  it "moves" do
    path2 = "/tmp/filesortdtest2"
    File.write path, "1"
    af = Afile.new(path)
    af.mv path2
    af.path.should == path2
    File.exists?(path).should be_false
    File.exists?(path2).should be_true
    File.unlink path2
  end

  it "removes" do
    File.write path, "1"
    af = Afile.new(path)
    af.rm
    af.path.should be_nil
    File.exists?(path).should be_false
  end

  it "pipes" do
    File.write path, "123"
    Afile.new(path).pipe("cat").should == "123"
    File.unlink path
  end

  it "passes" do
    File.write path, "123"
    Afile.new(path).pass("cat").should == "123"
    File.unlink path
  end

  it "labels" do
    if RbConfig::CONFIG['target_os'] =~ /darwin(1.+)?$/i
      File.write path, "123"
      Afile.new(path).label(:red)
      `osascript -e 'tell app "Finder" to get label index of (POSIX file "#{path}" as alias)'`.should == "2\n"
      File.unlink path
    end
  end

  it "runs applescript" do
    if RbConfig::CONFIG['target_os'] =~ /darwin(1.+)?$/i
      File.write path, "123"
      Afile.new(path).applescript('get POSIX path of theFile').should == path
      File.unlink path
    end
  end
end
