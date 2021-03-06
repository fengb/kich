Feature: benchmark installed

  Background:
      Given in KICH_SRC
        And there are 1000 files
        And I execute 'kich install'

  @benchmark
  Scenario: install 0/1000 files
       Then I execute 'kich install'

  @benchmark
  Scenario: clean 1000 unbroken files
       Then I execute 'kich install'

  @benchmark
  Scenario: uninstall 1000 files
       Then I execute 'kich uninstall <<<y'
