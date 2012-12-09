require "filesortd/cond"
include Filesortd

describe "os" do
  it "executes on freebsd" do
    RbConfig::CONFIG['target_os'] = 'freebsd'
    os(:freebsd) { true }.should be_true
    os(:linux) { true }.should be_nil
  end

  it "executes on osx" do
    RbConfig::CONFIG['target_os'] = 'darwin11.3.0'
    os(:osx) { true }.should be_true
    os(:linux) { true }.should be_nil
  end

  it "executes on linux" do
    RbConfig::CONFIG['target_os'] = 'linux'
    os(:linux) { true }.should be_true
    os(:osx) { true }.should be_nil
  end

  it "executes on windows" do
    RbConfig::CONFIG['target_os'] = 'mingw'
    os(:windows) { true }.should be_true
    os(:osx) { true }.should be_nil
  end
end
