@program cmd-id.muf
1 1000 d
i
( cmd-id.muf by Natasha@HLM
  A simple object describer.

  Copyright 2003 Natasha Snunkmeox. Copyright 2003 Here Lie Monsters.
  "@view $box/mit" for license information.

  Version history
  1.0, 25 Oct 2003: First version.
)
$author Natasha Snunkmeox <natmeox@neologasm.org>
$version 1.0
$note A simple object describer.

$include $lib/bits
$include $lib/syvel-funcs
$def .color-unparseobj obj-color
: main  ( str -- }  Print out the unparseobj for the given string. )
    dup strip "#help" stringcmp not if "_help" rtn-dohelp exit then  ( str )

    dup if match else pop me @ then  ( db )
    dup obj-color  ( db str )
    over ok? if  ( db str )
        over owner swap "%s     Owner: %D" fmtstring  ( db str )
        over exit? if  ( db str )
            over getlink obj-color swap "%s     Link: %s" fmtstring  ( db str )
        then  ( db str )
    then  ( db str )
    .tellgood pop  (  )
;
.
c
q
@act id;db=#0
@link id=cmd-id
lsedit cmd-id=_help
.del 1 $
id <object>
db <object>
 
Displays the name and dbref for the given object.
.end
