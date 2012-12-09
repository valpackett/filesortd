require "filesortd/afile"
include Filesortd

describe Afile do
  let(:path) { "/tmp/filesortdtest" }

  it "copies" do
    path2 = "/tmp/filesortdtest2"
    File.write path, "1"
    Afile.new(path).cp path2
    File.exists?(path).should be_true
    File.exists?(path2).should be_true
    File.unlink path
    File.unlink path2
  end

  it "moves" do
    path2 = "/tmp/filesortdtest2"
    File.write path, "1"
    Afile.new(path).mv path2
    File.exists?(path).should be_false
    File.exists?(path2).should be_true
    File.unlink path2
  end

  it "removes" do
    File.write path, "1"
    Afile.new(path).rm
    File.exists?(path).should be_false
  end

  it "pipes" do
    File.write path, "1+2"
    Afile.new(path).pipe("bc").should == "3"
    File.unlink path
  end

  it "passes" do
    File.write path, "123"
    Afile.new(path).pass("cat").should == "123"
    File.unlink path
  end
end
