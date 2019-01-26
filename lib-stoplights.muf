@program lib-stoplights.muf
1 9999 d
i
( lib-stoplights.muf by Natasha@HLM
  Clearly label success and error responses from MUF programs.

  Copyright 2019 Natasha Snunkmeox. Copyright 2019 Here Lie Monsters.
  "@view $box/mit" for license information.


  This library signals the presence of several MUF macros for clearly labeling
  command output as a success, error or warning. The original version for HLM
  defines these as:

      [%] in green: a good success
      [?] in yellow: a warning
      ]![ in red: a bad error

  Feel free to customize them for your MUCK when porting!

  You can use the `$iflib` directives in your program to determine if these
  macros are available:

      $ifnlib $lib/stoplights
          $def .tellgood .tell
          $def .tellwarn .tell
          $def .tellbad  .tell
      $endif

  The distributable version of this library defines these macros:

  .tell  { str -- }
  Display `str` to the current user. {This is a common macro most MUCKs already
  have.}

  .str-good  { -- str }
  .str-warn  { -- str }
  .str-bad   { -- str }
  Produce one of three "stoplights": a color coded string suitable for
  prepending onto a message to label it as a success, error or warning
  respectively.

  .notifygood  { db str -- }
  .notifywarn  { db str -- }
  .notifybad   { db str -- }
  As with `notify`, display `str` to `db`, but marked with the appropriate
  stoplight.

  .tellgood  { str -- }
  .tellwarn  { str -- }
  .tellbad   { str -- }
  As with the common `.tell` macro, display `str` to the current user, but
  marked with the appropriate stoplight.

)
: main ;
.
c
def str-good "\[[32m[\[[1;32m%\[[0;32m]\[[0m "
def str-bad "\[[31m]\[[1;31m!\[[0;31m[\[[0m "
def str-warn "\[[30m[\[[1;30m?\[[0;30m[\[[0m "
def notifybad .str-bad swap strcat notify
def notifygood .str-good swap strcat notify
def notifywarn .str-warn swap strcat notify
def tellbad .str-bad swap strcat .tell
def tellgood .str-good swap strcat .tell
def tellwarn .str-warn swap strcat .tell
def tell "me" match swap notify
q
@set lib-stoplights.muf=v
@set lib-stoplights.muf=!m
@register lib-stoplights.muf=lib/stoplights
