Feature: benchmark

  Background:
      Given in KICH_SRC
        And there are 1000 files

  @benchmark
  Scenario: install 1000 files into empty directory
       Then I benchmark 'kich install'

  @benchmark
  Scenario: clean empty directory
       Then I benchmark 'kich clean'

  @benchmark
  Scenario: uninstall empty directory
       Then I benchmark 'kich uninstall <<<y'
