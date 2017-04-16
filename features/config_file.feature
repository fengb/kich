Feature: kich -c FILE

  Scenario: <(echo KICH_SRC)
       When I execute 'kich -c <(echo KICH_SRC='banana') env'
       Then there should be output:
            """
            KICH_SRC='banana'
            KICH_TGT='$KICH_TGT'
            KICH_IGNORE=''
            """
  Scenario: <(echo KICH_TGT)
       When I execute 'kich -c <(echo KICH_TGT='cheese') env'
       Then there should be output:
            """
            KICH_SRC='$KICH_SRC'
            KICH_TGT='cheese'
            KICH_IGNORE=''
            """
  Scenario: <(echo KICH_IGNORE)
       When I execute 'kich -c <(echo KICH_IGNORE='salad') env'
       Then there should be output:
            """
            KICH_SRC='$KICH_SRC'
            KICH_TGT='$KICH_TGT'
            KICH_IGNORE='salad'
            """
