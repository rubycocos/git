## try multiple targets and vars passing in e.g.
##   $ make foo BAR=bbb bar FOO=aaa    -or-
##   $ make foo bar BAR=bbb FOO=aaa    -or-
##   $ make BAR=bbb FOO=aaa foo bar
##  does the order of vars matter?
##   =>  NO - all the same
##    results in:
##        aaa
##        bbb


.PHONY:  foo bar      ## PHONY needed? why? why not?

BAR :=  xxx_bar
FOO :=  yyy_foo

foo:  ;   @echo $(FOO) $(aaa)

bar:  ;   @echo $(BAR) $(aaa)

