Feature: kich sync

  Scenario: happy path
      Given in KICH_TGT
        And there is a file 'foo' with content:
            """
            Charlie Delta
            """
       When I execute 'kich sync $KICH_TGT/foo'
       Then in KICH_SRC
        And there should be a file 'foo' with content:
            """
            Charlie Delta
            """
        And in KICH_TGT
        And there should be a symlink 'foo' to '$KICH_SRC/foo'
