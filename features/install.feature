Feature: kich install

  Scenario: fresh install
      Given there are files in KICH_SRC:
            """
            abc
            directory/bazbay
            path.link/banana
            path.link/chocolate
            path.link/peanut-butter
            """
       When I execute 'kich install'
       Then there should be output:
            """
            ⇋  $KICH_TGT/abc
            ⇋  $KICH_TGT/directory/bazbay
            ⇋  $KICH_TGT/path
            """
        And there should be links in KICH_TGT:
            """
            abc
            directory/bazbay
            path
            """
        And there should not be files in KICH_TGT:
            """
            path.link/banana
            path.link/chocolate
            path.link/peanut-butter
            """
