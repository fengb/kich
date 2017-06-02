Feature: benchmark large target directory

  Background:
      Given in KICH_SRC
        And there are 100 files
        And in KICH_TGT
        And there are 10,000 files

  @benchmark
  Scenario: install 100 files into target with 10,000 files
       Then I benchmark 'kich install'

  @benchmark
  Scenario: clean 10,000 unbroken files
       Then I benchmark 'kich clean'

  @benchmark
  Scenario: uninstall nothing from 10,000 files
       Then I benchmark 'kich uninstall <<<y'
