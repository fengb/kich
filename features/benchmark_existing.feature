Feature: benchmark existing

  Background:
      Given in KICH_SRC
        And there are 1000 files
        And I execute 'kich install'

  @benchmark
  Scenario: install noop
       Then I benchmark 'kich install'

  @benchmark
  Scenario: uninstall existing
       Then I benchmark 'kich uninstall <<<y'
