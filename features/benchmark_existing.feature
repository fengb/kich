Feature: benchmark existing

  Background:
      Given in KICH_SRC
        And there are 100 files
        And I execute 'kich install'

  @benchmark
  Scenario: install noop
       Then I execute 'kich install'

  @benchmark
  Scenario: uninstall
       Then I execute 'kich uninstall <<<y'
