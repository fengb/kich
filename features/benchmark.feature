Feature: benchmark

  Background:
      Given in KICH_SRC
        And there are 1000 files

  @benchmark
  Scenario: install fresh
       Then I benchmark 'kich install'

  @benchmark
  Scenario: uninstall noop
       Then I benchmark 'kich uninstall <<<y'
