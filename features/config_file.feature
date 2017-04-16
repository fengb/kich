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
  Scenario: no file
       When I execute 'kich -c'
       Then there should be error:
            """
            kich: '-c' requires an argument
            """
  Scenario: missing file
       When I execute 'kich -c MISSINGNO.'
       Then there should be error:
            """
            kich: config file 'MISSINGNO.' not found
            """
