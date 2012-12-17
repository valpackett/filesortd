require "rspec/expectations"
require "filesortd"
include Filesortd

Before do
  @listeners = []
end

After do
  @listeners.each do |l|
    l.stop
  end
  @listeners = []
end

Given /^the folder "(.*?)" exists$/ do |path|
  FileUtils.mkdir path
end

Given /^filesortd listens to "(.*?)" and removes files$/ do |path|
  folder path do
    any do
      rm
    end
  end
end

Given /^filesortd listens to 3 folders "(.*?)", "(.*?)", "(.*?)" and removes files$/ do |p1, p2, p3|
  folders p1, p2, p3 do
    any do
      rm
    end
  end
end

When /^I create "(.*?)"$/ do |path|
  File.write path, "123"
end

When /^I wait (\d+) seconds$/ do |s|
  sleep s.to_i
end

Then /^"(.*?)" should not exist$/ do |path|
  File.exists?(path).should be_false
end

Then /^remove folder "(.*?)"$/ do |path|
  FileUtils.rmdir path
end
