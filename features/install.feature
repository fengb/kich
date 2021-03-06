Feature: kich install

  Scenario: fresh install
      Given in KICH_SRC
        And there are files:
            """
            abc
            dir/bay/baz
            path.link/banana
            path.link/chocolate
            path.link/peanut-butter
            """
       When I execute 'kich install'
       Then there should be output:
            """
            ⇋  $KICH_TGT/abc
            ⇋  $KICH_TGT/dir/bay/baz
            ⇋  $KICH_TGT/path
            """
        And in KICH_TGT
        And there should be symlinks:
            | abc         | $KICH_SRC/abc         |
            | dir/bay/baz | $KICH_SRC/dir/bay/baz |
            | path        | $KICH_SRC/path.link   |
        And in KICH_TGT
        And there should not be files:
            """
            path.link/banana
            path.link/chocolate
            path.link/peanut-butter
            """
       When I execute 'kich install'
       Then there should be no output
