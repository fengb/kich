Feature: kich install

  Scenario: fresh install
      Given in KICH_SRC there are files:
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
        And in KICH_TGT there should be symlinks:
            """
            abc
            directory/bazbay
            path
            """
        And in KICH_TGT there should not be files:
            """
            path.link/banana
            path.link/chocolate
            path.link/peanut-butter
            """
       When I execute 'kich install'
       Then there should be no output
