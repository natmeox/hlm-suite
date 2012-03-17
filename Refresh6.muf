@program Refresh6.muf
1 1000 d
i
( Refresh6.muf by Natasha@HLM
  Whospecies redux for Fuzzball 6.

  Copyright 2002 Natasha O'Brien. Copyright 2002 Here Lie Monsters.
  "@view $box/mit" for license information.

  Refresh6 uses line formats to completely modularize how it appears. It
  looks up the environment, so area builders can customize its appearance
  if they wish.

  @set lines with the array_fmtstrings syntax like this:

@set #0=_prefs/ws/header:Stat  Name________________  Sex________  Species_______________________________
@set #0=_prefs/ws/footer:%%----( %[awake]i/%[count]i%.45[room]s }---
@set #0=_prefs/ws/line:%[@statcolor]s%-4.4[status]s  %[@awakecolor]s%-20.20[@n]s  %[@sexcolor]s%-11.11[sex]s  %[species]s

  The header and footer lines have special codes:

  %[awake]i  The number of awake players in the listing.
  %[count]i  The total number of players in the listing.
   %[room]s  The name of the room being listed, prepended with a space. In
             #far listings, this is the null string.
        %%-  A string of dashes, to fill the line out to 79 characters.
         \[  An escape code for a Fuzzball 6 ANSI color string.

  Unlike in header and footer lines, the "line" setting *does not* parse
  "\[" into the escape code. You'll have to pre-parse it when you save the
  setting, by saving it with @mpi {store} and your raw ansi colors or {attr}.

  Codes in the "line" format:
  
   [@statcolor]  The special color associated with that player's status.
  [@awakecolor]  "\[[1m" if the player is awake; the reset code otherwise.
                 This makes sleeping players' lines dim.
    [@sexcolor]  The special color associated with that player's gender. The
                 color depends on the first two characters of the player's
                 "gender" prop; if not set, then the "sex" prop.
        [@name]  The player's name.
        [@idle]  How long the player has been idle, eg, "2m", or the null
                 string if the player is less than two minutes idle.
           [@n]  The player's name. If the player is asleep or idle, it
                 also includes an "[asleep]" or "[2m idle]" tag after.
       [string]  The value of that property.
)
$include $lib/strings
$include $lib/bits
$include $lib/away  (added Natasha@HLM 27 December 2002)

$def prop_status "status"
$def prop_far_object "_prefs/ws/object"
$def prop_dim_sleepers "_prefs/ws/dimsleepers"
$def prop_doing "_prefs/ws/doing"
$def prop_idle_time "_prefs/ws/idle"

lvar metadata
lvar idletime
lvar doingfmt
lvar is_afar
lvar redact

( *** utility bits )

: rtn-parse-hf  ( str -- str' }  Parses a header or footer for special codes. )
    "\[" "\\[" subst  ( str )

    metadata @ 1 array_make swap array_fmtstrings  ( arr )
    dup array_first pop array_getitem  ( str )

    ( Fix the line. )
    dup "%-" instr if  ( str )
        79 over ansi_strlen 2 - -  ( str intLength )
        "--------------------------------------------------------------------------------" swap strcut pop  ( str strLine )
        "%-" subst  ( str )
    then  ( str )
;

: rtn-get-pref  ( db str -- str' }  Gets db's pref of the given name. )
    "_prefs/ws/" swap strcat  ( db str )
    envpropstr swap pop  ( str' )
;

: rtn-valid-who  ( db -- bool }  Returns true if this db is a player we can list. )
    dup ok? if
        dup thing? over "z" flag? and if pop 1 exit then  ( db )
        dup player? if me @ swap ignoring? not else pop 0 then  ( bool )
    else pop 0 then  ( bool )
;

( *** data getters )

: rtn-data-name name ;
: rtn-data-idle owner descrleastidle descridle dup idletime @ > if .stimestr else pop "" then ;

: rtn-data-doing  ( db -- str )
    redact @ if pop "" exit then
    doingfmt @ dup if  ( db strFmt )
        swap "_/do" getpropstr dup if  ( strFmt strDoing )
            "<my pretty doing>" subst  ( str )
        else pop pop "" then  ( str )
    else pop pop "" then  ( str )
;

: rtn-data-awakecolor  ( db -- str )
    awake? not not "\[[%im" fmtstring
;
: rtn-data-bright pop "\[[1m" ;

: rtn-data-statcolor  ( db -- str )
    redact @ if pop "" exit then
    prop_status getpropstr strip  ( strStatus )
    dup if  ( strStatus )
        prog "_stat2color/" rot strcat getpropstr  ( strColor )
        dup if "\[" "\\[" subst then  ( strColor )
    then  ( str }  strColor or an empty strStatus. )
;

: rtn-data-sexcolor  ( db -- str }  Gets the character's gender, with color and whatnot. )
    redact @ if pop "" exit then  ( db )
    "_prefs/ws/color/%a" pronoun_sub  ( strProp )
    1 try  ( strProp )
        me @ swap envpropstr swap pop  ( strColor )
    catch pop "" endcatch  ( strColor )
    dup if "\[" "\\[" subst else pop "\[[37m" then  ( strColor )
;

: rtn-data-n  ( db -- str )
    dup name  ( db str )
    over awake? not if  ( db str )
        "\[[0;34m[\[[1;34masleep\[[0;34m]" strcat  ( db str )
    else over "i" flag? if  ( db str )
        "\[[0;31m[\[[1;31mbusy\[[0;31m]" strcat  ( db str )
    else over away-away? if  ( db str }  Changed to use $lib/away fn Natasha@HLM 27 December 2002 )
        "\[[0;36m[\[[1;36maway\[[0;36m]" strcat  ( db str )
    else over rtn-data-idle dup if  ( str strIdle )
        strip "\[[0;36m[\[[1;36m%s idle\[[0;36m]" fmtstring strcat  ( str )
    else pop then then then then  ( db str )

    over thing? 3 pick "z" flag? and if
        over owner "\[[0;35m[\[[1;35m%D's\[[0;35m]" fmtstring strcat  ( db str )
    then  ( db str )

    swap pop  ( str )
;

$define dict_atdata {
    "@n"     'rtn-data-n
    "@name"  'rtn-data-name
    "@idle"  'rtn-data-idle
    "@doing" 'rtn-data-doing

    "@sexcolor"   'rtn-data-sexcolor
    "@statcolor"  'rtn-data-statcolor
    "@awakecolor" 'rtn-data-awakecolor
    "@awakecolor2" 'rtn-data-awakecolor
}dict $enddef

( *** #commands )

: do-help pop pop "_help" rtn-dohelp ;

: do-object  ( strY strZ -- )
    pop pop  (  )
    me @ prop_far_object "yes" setprop  (  )
    "You object to ws #far." .tellgood
;

: do-!object  ( strY strZ -- )
    pop pop  (  )
    me @ prop_far_object remove_prop  (  )
    "You allow ws #far." .tellgood
;

: do-bright  ( strY strZ -- )
    pop pop  (  )
    me @ prop_dim_sleepers "no" setprop  (  )
    "Sleepers will not be shown dim." .tellgood  (  )
;

: do-!bright  ( strY strZ -- )
    pop pop  (  )
    me @ prop_dim_sleepers remove_prop  (  )
    "Sleepers will be shown with dim colors." .tellgood  (  )
;

: do-doing  ( strY strZ -- )
    pop pop  (  )
    me @ prop_doing "yes" setprop  (  )
    "Players' @doings will be shown where available." .tellgood  (  )
;

: do-!doing  ( strY strZ -- )
    pop pop  (  )
    me @ prop_doing remove_prop  (  )
    "Players' @doings will not be shown." .tellgood  (  )
;

: do-idle  ( strY strZ -- )
    pop  ( strY )
    dup number? not if  ( strY )
        "'%s' is not a number." fmtstring .tellbad  (  )
        exit  (  )
    then atoi  ( int )
    me @ prop_idle_time 3 pick intostr setprop  ( int )
    .mtimestr "You will only see idle times more than %s." fmtstring .tellgood  (  )
;

: do-far  ( strY strZ -- arrDb }  Lists all the people in strY, if they allow it. )
    pop  ( strY )
    " " explode_array  ( arrNames )
    { }list swap  ( arrNames )
    foreach swap pop  ( arrDb strName )
        dup .pmatch  ( arrDb strName db )
        dup rtn-valid-who not if  ( arrDb strName db )
            pop  ( arrDb strName )
            "I don't see whom you mean by '%s'." fmtstring .tellbad  ( arrDb )
            continue  ( arrDb )
        then swap pop  ( arrDb db )
        
        swap array_appenditem  ( arrDb )
    repeat  ( arrDb )
    1 is_afar !
;

: do-listhere  ( strY strZ -- arrContents }  Returns an array of all the players/objects here whose names start with strY. )
    pop  ( strY )
    loc @ contents_array  ( strY arrContents )
    over if
        0 array_make swap  ( strY arrContents' arrContents )
        foreach swap pop  ( strY arrContents db )
            dup name 4 pick stringpfx if  ( strY arrContents db )
                dup rot array_appenditem swap  ( strY arrContents db )
            then  ( strY arrContents db )
        pop repeat  ( strY arrContents )
    then  ( strY arrContents' )
    swap pop  ( arrContents' )
;

$define dict_commands {
    ""        'do-listhere
    "far"     'do-far
    "object"  'do-object
    "!object" 'do-!object
    "bright"  'do-bright
    "!bright" 'do-!bright
    "idle"    'do-idle
    "doing"   'do-doing
    "!doing"  'do-!doing
    "help"    'do-help
}dict $enddef

: main  ( str -- )
    0 is_afar !

    ( Have we entered a command? )
    dup if  ( str )
        STRparse  ( strX strY strZ }  #X y=z )
        0 try
            dict_commands command @ 5 pick strcat array_getitem  ( strX strY strZ adr )
        catch endcatch  ( strX strY strZ ? }  ? is either adr or catch's strError )
        dup address? if  ( strX strY strZ adr )
            4 rotate pop  ( strY strZ adr )
            execute  (  )
            0 try
                dup array? not if
                    exit
                then
            catch pop exit endcatch  ( arrWho )
        else  ( strX strY strZ ? )
            pop pop pop
            "I don't understand the command '%s'." fmtstring .tellbad  (  )
            exit  (  )
        then  ( arrWho )
        { "room" "" "awake" 0 "count" 0 }dict metadata !  ( arrWho )
    else pop  (  )
        loc @  ( db )
        dup "d" flag? me @ 3 pick controls not and if  ( db )
            pop "This room is too dark to see." .tellbad  (  )
            exit  (  )
        then  ( db )
        " " over name strcat
        { "room" rot "awake" 0 "count" 0 }dict metadata !  ( db )
        contents_array  ( arrWho )
    then  ( arrWho )

    ( Get the line format. )
    me @ "line" rtn-get-pref  ( arrWho strFormat )

    ( What data do we need for this format? )
    dict_atdata  ( arrWho strFormat dict )
    ( Hey, set some options. )
    me @ prop_dim_sleepers getpropstr .no? if
        'rtn-data-bright swap "@awakecolor" array_setitem
        'rtn-data-bright swap "@awakecolor2" array_setitem
    then  ( arrWho strFormat dict )
    me @ prop_idle_time getpropstr dup number? if atoi else pop 180 then idletime !
    me @ prop_doing getpropstr .yes? if loc @ "doing" rtn-get-pref else "" then doingfmt !

    var! atdata  ( arrWho strFormat dict )

    { }dict over  ( arrWho strFormat dict str )
    begin  ( .. dict str )
        "[]" "" tokensplit ( .. dict strPre str strChar )
        over over and  ( .. dict strPre str strChar boolSplit )
    while  ( .. dict strPre str strChar )
        "[" strcmp if  ( .. dict strPre str )
            ( Close bracket; what data do we want? )
            swap  ( .. dict str strPre )
            dup "@" stringpfx if  ( .. dict str strPre )
                dup atdata @ swap array_getitem
            else dup then  ( .. dict str strPre ? )

            4 rotate rot  ( .. str ? dict strPre )
            array_setitem  ( .. str dict )
            swap  ( .. dict str )

        else swap pop then  ( .. dict str )
    repeat pop pop pop  ( arrWho strFormat dict )

    ( Compile all the data on all these people. )
    { }list 4 rotate  ( strFormat dictProto arrData arrWho )
    foreach swap pop  ( strFormat dictProto arrData db )

        ( Is this an object we can list? )
        dup rtn-valid-who not if pop continue then  ( strFormat dictProto arrData db )
        metadata @
        dup "count" array_getitem 1 + swap "count" array_setitem
        over awake? if
            dup "awake" array_getitem 1 + swap "awake" array_setitem
        then
        metadata !

        { }dict  ( strFormat dictProto arrData db dictDatum )
        4 pick foreach  ( strFormat dictProto arrData db dictDatum strKey ?Value )
            4 pick swap  ( strFormat dictProto arrData db dictDatum strKey db ?Value )

            is_afar @ if  ( strFormat dictProto arrData db dictDatum strKey db strProp )
                over prop_far_object getpropstr .yes?  ( strFormat dictProto arrData db dictDatum strKey db strProp boolRedact )
            else 0 then redact !

            dup address? if
                execute
            else  ( strFormat dictProto arrData db dictDatum strKey db strProp )
                redact @ if pop pop "\[[1;30mredacted" else getpropstr then
            then  ( strFormat dictProto arrData db dictDatum strKey strValue )

            rot rot array_setitem  ( strFormat dictProto arrData db dictDatum' )
        repeat  ( strFormat dictProto arrData db dictDatum )
        swap pop  ( strFormat dictProto arrData dictDatum )
        swap array_appenditem  ( strFormat dictProto arrData )
    repeat swap pop  ( strFormat arrData )

    ( We have some data, right? )
    dup array_count 1 < if  ( strFormat arrData )
        pop pop  (  )
        "No one to show." .tellbad  (  )
        exit  (  )
    then  ( strFormat arrData )

    swap array_fmtstrings  ( arrOutput )

    me @ "header" rtn-get-pref  ( arrOutput strHeader )
    rtn-parse-hf  ( arrOutput strHeader )
    swap 0 array_insertitem  ( arrOutput )
    me @ "footer" rtn-get-pref  ( arrOutput strFooter )
    rtn-parse-hf  ( arrOutput strHeader )
    swap array_appenditem  ( arrOutput )

    { me @ }list array_notify  (  )
;
.
c
q
@reg Refresh6=prog/whospecies
@set refresh6=!l
@set refresh6=w

@set #0=_prefs/ws/header:\[[1;37mStat  Name_______\[[0;37m_______\[[1;30m______  \[[37mSex__\[[0;37m___\[[1;30m___  \[[37mSpecies_________\[[0;37m_________\[[1;30m_________\[[0m
do @set #0=_prefs/ws/line:%[@awakecolor]s%[@statcolor]s%-4.4[status]s  \[[37m%-24.24[@n]s  %[@awakecolor2]s%[@sexcolor]s%-11.11[sex]s  \[[37m%[species]s%[@doing]s
do @set #0=_prefs/ws/doing:\r        \[[1;35mDoing: \[[0;35m<my pretty doing>
@set #0=_prefs/ws/footer:\[[1;30m%%--\[[0;37m-\[[1m-( %[awake]i/%[count]i%.45[room]s )-\[[0;37m-\[[1;30m-\[[0m

@set refr=_stat2color/IC:\[[32m
@set refr=_stat2color/OOC:\[[33m
@set refr=_stat2color/WIZ:\[[36m

@set #0=_prefs/ws/color/his:\[[36m
@set #0=_prefs/ws/color/hers:\[[35m


lsedit refr=_help
.del 1 $
ws
ws #far <name> [<name>...]
 
Lists the people in the room, their genders, and species. The 'status' command can set your Status field; see 'status #help'. If someone's ws #far shows "redacted," they have used the #object option to hide that data. ws also has several customization options:
 
  #object       Disable display of your data in ws #far lists.
  #doing        Enable display of players' @doings.
  #bright       Disable display of sleepers with dimmer ANSI colors.
  #idle <secs>  Display idle times only if more than <secs> seconds.
 
The first three options can also be turned off with, for example, 'ws #!object'.
.format 11=78
.format 4=78
.end
