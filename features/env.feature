Feature: kich sync

  Scenario: happy path
       When I execute 'kich env'
       Then there should be output:
            """
            KICH_SRC='$KICH_SRC'
            KICH_TGT='$KICH_TGT'
            KICH_IGNORE=''
            """
