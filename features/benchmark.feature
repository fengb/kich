Feature: benchmark

  Background:
      Given in KICH_SRC
        And there are 100 files
        And I execute 'kich install'

  @benchmark
  Scenario: install fresh
       Then I execute 'kich install'

  @benchmark
  Scenario: uninstall noop
       Then I execute 'kich uninstall <<<y'
