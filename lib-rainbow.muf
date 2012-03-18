@program lib-rainbow.muf
1 1000 d
i
( lib-rainbow.muf by Natasha@HLM
  Adds rainbow color to a string.

  Copyright 2003 Natasha Snunkmeox. Copyright 2003 Here Lie Monsters.
  "@view $box/mit" for license information.
)
$author Natasha Snunkmeox <natmeox@neologasm.org>
$version 1.0
$note Adds rainbow color to a string.
: rainbow  ( str -- str' )
    random 6 % var! color
    "" swap  ( str- -str )
    begin dup while  ( str- -str )
        1 strcut  ( str- -str- -str )
        -3 rotate  ( -str str- -str- )
        dup striplead if  ( -str str- -str- )
            swap  ( -str -str- str- )
            prog color @ "_color/%i" fmtstring getpropval swap  ( -str -str- intColor str- )
            "%s\[[1;3%im%s" fmtstring  ( -str str- )

            color @ 1 + 6 % color !  ( -str str- )
        else strcat then swap  ( str- -str )
    repeat pop  ( str' )
    "\[[0m" strcat
;
PUBLIC rainbow
$libdef rainbow
.
c
q
@reg lib-rainbow=lib/rainbow
@set $lib/rainbow=l
@set $lib/rainbow=v
@set #0=_msgmacs/rainbow:{muf:$lib/rainbow,{:1}}
@propset $lib/rainbow=int:_color/0:1
@propset $lib/rainbow=int:_color/1:3
@propset $lib/rainbow=int:_color/2:2
@propset $lib/rainbow=int:_color/3:6
@propset $lib/rainbow=int:_color/4:4
@propset $lib/rainbow=int:_color/5:5
