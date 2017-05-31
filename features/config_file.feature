Feature: kich -c FILE

  Scenario: KICH_SRC='banana'
      Given there is a $configfile with content:
            """
            KICH_SRC='banana'
            """
       When I execute 'kich -c $configfile env'
       Then there should be output:
            """
            KICH_SRC='banana'
            KICH_TGT='$KICH_TGT'
            KICH_IGNORE=''
            """
  Scenario: KICH_TGT='cheese'
      Given there is a $configfile with content:
            """
            KICH_TGT='cheese'
            """
       When I execute 'kich -c $configfile env'
       Then there should be output:
            """
            KICH_SRC='$KICH_SRC'
            KICH_TGT='cheese'
            KICH_IGNORE=''
            """
  Scenario: KICH_IGNORE='salad'
      Given there is a $configfile with content:
            """
            KICH_IGNORE='salad'
            """
       When I execute 'kich -c $configfile env'
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
