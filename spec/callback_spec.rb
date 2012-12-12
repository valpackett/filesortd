require "filesortd/callback"
include Filesortd

describe Callback do
  let(:cb) { Callback.new }

  it "executes callbacks for matched paths" do
    true_matcher = double("matcher", :match => true)
    false_matcher = double("matcher", :match => false)
    true_called = false_called = false
    cb.matchers[ true_matcher] = Proc.new {  true_called = true }
    cb.matchers[false_matcher] = Proc.new { false_called = true }
    cb.call([""])
    true_called.should be_true
    false_called.should be_false
  end
end
