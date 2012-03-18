@program cmd-paste.muf
1 1000 d
i
( cmd-paste.muf
  Multi-line message sending program. Based vaguely on Deedlit's.

  Copyright 2004 Natasha Snunkmeox. Copyright 2004 Here Lie Monsters.
  "@view $box/mit" for license information.
)
$author Natasha Snunkmeox <natmeox@neologasm.org>
$version 1.0
$note Multi-line message sending program.

$include $lib/alias
$include $lib/editor
$include $lib/strings

$def prop_ok "_prefs/paste_ok"

: do-paste[ str:who -- ] ( Enter the list editor to paste a list to the given people. )
    who @ not if
        "Paste to whom?" .tellbad
        pop exit  (  )
    then  ( str )

    ( Who? )
    me @ who @ alias-expand  ( arrDb )
    dup not if
        "Paste to whom?" .tellbad
        pop exit
    then  ( arrDb )

    dup prop_ok "{y*|1}" array_filter_prop  ( arrDb arrOk )
    dup rot array_diff  ( arrOk arrNotOk )
    dup if  ( arrOk arrNotOk )
        dup array_count 1 = if
            0 array_getitem "%D is not accepting @pastes." fmtstring .tellbad  ( arrOk )
        else dup array_count 2 = if
            array_vals pop "%D and %D are not accepting @pastes." fmtstring .tellbad  ( arrOk )
        else
            array_interpret
            ", " " " subst
            " " rinstr strcut " and" swap strcat strcat
            " are not accepting @pastes." strcat .tellbad  ( arrOk )
        then then
    else pop then  ( arrOk )

    dup not if exit then  ( arrOk )

    read_wants_blanks 0 EDITOR  ( arrOk strN..str1 intN strExit )
    "end" stringcmp if
        "Paste aborted." .tellbad
        popn pop exit  (  )
    then array_make  ( arrOk arrMsg )

    dup array_count me @ "---- Paste from %D (%i lines) ----" fmtstring  ( arrOk arrMsg strHead )
    "" "-" 3 pick strlen STRfillfield
    "\[[1m%s\[[0m" fmtstring  ( arrOk arrMsg strHead strFoot )
    rot array_appenditem  ( arrOk strHead arrMsg )
    swap "\[[1m%s\[[0m" fmtstring swap
    0 array_insertitem  ( arrOk arrMsg )

    swap me @ swap array_appenditem array_notify  (  )
;


: do-ok[ str:y -- ]
    me @ prop_ok "yes" setprop
    "Players can now @paste to you." .tellgood
;

: do-unok[ str:y -- ]
    me @ prop_ok remove_prop
    "Players can no longer @paste to you." .tellgood
;

: do-help pop .showhelp ;

$define dict_commands {
    0      'do-paste
    "ok"   'do-ok
    "!ok"  'do-unok
    "help" 'do-help
}dict $enddef

: main  ( str -- )
    STRparse pop  ( strX strY }  cmd #x y )
    over over or not if pop pop "help" "" then  ( strX strY )

    dict_commands 3 pick array_getitem  ( strX strY ? )
    dup address? if  ( strX strY adr )
        rot pop  ( strY adr )
        execute  (  )
    else  ( strX strY ? )
        pop pop  ( strX )
        command @ "I don't know what you mean by '#%s'. Try '%s #help'." fmtstring .tellbad  (  )
    then  (  )
;
.
c
q
