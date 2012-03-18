@program con-laston.muf
1 1000 d
i
( con-laston.muf by Natasha@HLM
  Sets users' @/laston and @/lastoff props appropriately, for use with Natasha's cmd-laston.

  Copyright 2002 Natasha Snunkmeox. Copyright 2002 Here Lie Monsters.
  "@view $box/mit" for license information.
)
: main  ( str -- )
    systime  ( str int )
    background  ( str int )
    intostr  ( str strSecs )

    swap "Connect" strcmp if "@/last/off" else "@/last/on" then  ( strSecs strProp )
    me @ over 4 pick setprop  ( strSecs strProp )
    me @ over array_get_proplist  ( strSecs strProp arrTimes )
    rot swap array_appenditem  ( strProp arrTimes )
    dup array_count 10 > if
        0 array_delitem  ( strProp arrTimes )
    then
    me @ -3 rotate array_put_proplist  (  )
;
.
c
q
@set con-laston=l
@set con-laston=w
