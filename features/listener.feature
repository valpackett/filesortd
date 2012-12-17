Feature: Listener
  In order to sort files
  As a filesortd user
  I want filesortd to listen to file system events and do actions I want

  Scenario: One folder
    Given the folder "/tmp/fsdlistener" exists
      And filesortd listens to "/tmp/fsdlistener" and removes files
    When I create "/tmp/fsdlistener/hello"
     And I wait 2 seconds
    Then "/tmp/fsdlistener/hello" should not exist

  Scenario: Many folders
    Given the folder "/tmp/fsdlistener1" exists
      And the folder "/tmp/fsdlistener2" exists
      And the folder "/tmp/fsdlistener3" exists
      And filesortd listens to 3 folders "/tmp/fsdlistener1", "/tmp/fsdlistener2", "/tmp/fsdlistener3" and removes files
    When I create "/tmp/fsdlistener1/hello1"
     And I create "/tmp/fsdlistener2/hello2"
     And I create "/tmp/fsdlistener3/hello3"
     And I wait 2 seconds
    Then "/tmp/fsdlistener1/hello1" should not exist
     And "/tmp/fsdlistener2/hello2" should not exist
     And "/tmp/fsdlistener3/hello3" should not exist
    Then remove folder "/tmp/fsdlistener1"
     And remove folder "/tmp/fsdlistener2"
     And remove folder "/tmp/fsdlistener3"
