@program Cityscape2.muf
1 9999 d
i
( Cityscape2.muf v2.1 by Natasha@SPR

  Requires Tjost's QuickSort lib/muf/thing.

* To install:
    You'll probably want to make an MPI macro to call the program. @Set this
    prop on your envroom:

        @set <envroom>=_msgmacs/cityscape:{muf:#ref,}

    <envroom> is your environment room of choice, #ref is the dbref of this
    program. 'cityscape' can be any name, but by using 'cityscape' instead of
    something like 'obv-exits', you ensure that you won't clash with any other
    obvious exits programs your MUCK might have installed.

    The easy use is '@succ here={cityscape}' when you're in a room you want to
    use Cityscape in, which is under an environment room with a macro set as
    above. If you changed the word 'cityscape' in the @set above, change it here,
    too.

* Setting up exits:
    Cityscape works by looking at the _obvex/marker props on the exits of a room
    to put them in groups. If you have a group of 'Homes' exits, then you might:

        @set <each exit>=_obvex/marker:homes

    Note that the _obvex/marker prop doesn't really have any bearing on the
    label: the same 'Homes' exits could have a marker of 'Elephant Ears' for all
    Cityscape cares, though the only reason you would want to not have a common-
    sense marker for your exits is that the groups are listed in alphabetical
    order by *marker*, not label.

    By default, the group of exits with no marker goes first, though you can
    have a marker on all the exits if you want.

    Either on that room or up the environment, you'll want to set an
    _obvex/name/<marker> prop for every marker you used. This prop defines the
    label used for the exits with marker <marker>. If you're missing one of
    these, it'll use the default 'Obvious Exits'.

    If you want to change the name of the group with no markers, use the prop
    _obvex/name.

    By default, an exit set Dark won't be shown. If you want to show a Dark exit,
    @set it _obvex/show?:yes.

    The exits in each individual group will be sorted by length, the longest
    appearing first. To make it not do this, have a _obvex/sort?:no prop up
    the environment from the desired room.

* Example:
    You install Cityscape.muf as #405. Your envroom is #85, so you type:

        @set #85=_msgmacs/cityscape:{muf:#405,}

    You have a room you want to use Cityscape in, with exits named
    '<E>ast;east;e', '<N>orth;north;n', and 'Dragons' Dew <I>nn;inn;i;west;w'.
    You type:

        @succ here={cityscape}

    You look at the room, and see:

      [ Obvious Exits: Dragons' Dew <I>nn, <N>orth, <E>ast                 ]

    This looks nice, but you want <N>orth and <E>ast in a different group from
    <I>nn. So you type:

        @set north=_obvex/marker:street
        @set east=_obvex/marker:street
        @set here=_obvex/name:Buildings

    You look again and see:

      [     Buildings: Dragons' Dew <I>nn                                  ]
      [ Obvious Exits: <N>orth, <E>ast                                     ]

    Easy, no? ;]

* Setting colors:
    If you don't have ansi color enabled, skip this, 'cause color is automagically
    disabled in your rooms. Simple, no?

    There are five differentiable colors. They're called and refer to:
      angb -- ANGle Brackets; the < and > in '<W>est'.
      squb -- The SQUare Brackets at the ends of each line.
      main -- The primary letter of the exit; the W in '<W>est'.
      norm -- Normal words; the 'est' in '<W>est'.
      labl -- The group LABeLs, such as 'Obvious Exits' or 'Buildings'.

    You can change the defaults that you personally--or that people in your area--
    will see, by setting the _obvex/xxxx prop on your room or environment {or
    self}, where xxxx is the name of the color. Each prop should be set to the
    first two numbers of the three-digit Caspiansi code.

    The defaults are gloom {100} for squb, white {170} for labl, crimson {010} for
    angb, white {170} for main, and gray {070} for norm.

    If, like Speckles, you like the idea of removing the <>s from '<W>est' and
    just having the W hilighted, you can set the prop '_obvex/no_angb' on you or
    your area to do that. So nyeh. ;]

* MPI macros for color
    If you're a design freak like I am, you may want to have some colors match your
    obvex; to keep you from manually changing color codes, you can use these macros
    {provided the person who installed Cityscape in your area/on your MUCK installed
    them}:

      Use {cs-code} where 'code' is one of the codes from the 'Setting colors'
      section above.

    If you'd like to install these macros, their code is:

@set #0=_msgmacs/cs-clr:~&{if:{prop:_obvex/{:1},me},{prop:_obvex/{:1},me},{:2}}
@set #0=_msgmacs/cs-angb:{cs-clr:angb,010}
@set #0=_msgmacs/cs-squb:{cs-clr:squb,100}
@set #0=_msgmacs/cs-main:{cs-clr:main,170}
@set #0=_msgmacs/cs-norm:{cs-clr:norm,070}
@set #0=_msgmacs/cs-labl:{cs-clr:labl,170}


  Copyright 2000-2001 Natasha Snunkmeox

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files {the "Software"}, to
  deal in the Software without restriction, including without limitation the
  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
  sell copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
  IN THE SOFTWARE.
)
( NEW in Cityscape 2.0:

  To set for paths:
  Preferences:
  _prefs/cityscape/firstn:1  --  Only use the first exit name.
  _prefs/cityscape/firstn:2  --  Use the first two exit names.
  _prefs/cityscape/firstn:  --  If not present, use the first exit name if { or < are present; otherwise use first two.

  _prefs/cityscape/useparens:  --  If present, use parentheses when using two exit names. Else use pointed brackets.
  _prefs/cityscape/linelength:<value>  --  Limit lines to a total of <value> characters.
)
(
  2.1 fixes a bug where Cityscape would error out if there are no exits on the given trigger.
)

(Set the line below equal to the dbref of Tjost's quicksort library.)
$def prog_quicksort #228

(Uncomment the line below for path support.)
$def Glow


$def propdir_temp "_temp/cityscape/"
$def propdir_pref "_prefs/cityscape/"


(
  getprefstr { s -- s' }
  Loads the preference 's' from wherever it's set.
)
$def getprefstr me @ swap propdir_pref swap strcat envpropstr swap pop


( Set up ansi color depending on if we $def'd Glow above or not. )
$ifdef Glow
$def ansi_tell me @ swap ansi_notify
$def ansi? "c" flag?
$else
$include $lib/ansi
$endif


lvar v_tempprop
lvar v_currentprop
lvar v_firstn
lvar v_howmanyexits
lvar v_maxlabellength
lvar v_string
lvar v_linelength
lvar v_color_squb
lvar v_color_angb
lvar v_color_main
lvar v_color_norm
lvar v_color_labl
$ifdef Glow
lvar v_pathdirlength
$endif

: rtn-getexitname  ( s -- s' }  Given an exit/path fullname, return the name formatted for display by Cityscape. )
    ( Does it contain a ';'? If not, just use the name as given. )
    dup ";" instr if  ( s )
        ( But it does! Do magic. *nod* )
        ( Do we do the first one or two names? )
        v_firstn @ not if  ( s )
            dup dup ";" instr strcut pop  ( s s- )
            dup "<" instr swap "(" instr or  ( s b }  b=whether or not the name has a { or < in it. )
            if 1 else 2 then  ( s i )
        else v_firstn @ then  ( s i }  i=number of exit names to use )
        1 = if  ( s )
            ( We use one. )
            dup ";" instr 1 - strcut pop  ( s' }  s'=name to use )
        else
            ( We use two. )
            dup ";" instr 1 - strcut  ( s- -s )
            1 strcut swap pop  ( s- -s )
            dup ";" instr dup if 1 - strcut pop else pop then  ( s- -s )
            ( OK, so do we use {s or <s? )
            "useparens" getprefstr if  ( s- -s )
                "(" -3 rotate  ( < s- -s )
                ") " swap  ( < s- > -s )
            else
                "<" -3 rotate  ( < s- -s )
                "> " swap  ( < s- > -s )
            then  ( < s- > -s )
            strcat strcat strcat  ( s' )
        then  ( s' )
    then  ( s' }  s'=name to use )
;

: rtn-color-line  ( s -- s' }  Given a string, color stuff. La. )
    ( Replace the things that we know where are. )
    ( Color the first square bracket.. )
    v_color_squb @ swap strcat  ( s )
    ( Color the label.. )
    ( We know that at the beginning is an ansi code, so we can get around a bug in the ansi_strcut in Caspian's lib/ansi library, using normal strcut. )
    6 strcut v_color_labl @ swap strcat strcat  ( s )
    ( Color the insides normally.. )
    4 v_maxlabellength @ + ansi_strcut v_color_norm @ swap strcat strcat  ( s )
    ( And color the last bracket. )
    dup strlen 1 - strcut v_color_squb @ swap strcat strcat  ( s )

    ( Now color the variable stuff: the angly brackets. )
    v_color_angb @ "<" strcat v_color_main @ strcat "<" subst
    v_color_angb @ ">" strcat v_color_norm @ strcat ">" subst
    v_color_angb @ "(" strcat v_color_main @ strcat "(" subst
    v_color_angb @ ")" strcat v_color_norm @ strcat ")" subst
;

: rtn-sortbylength  ( x1 x2 -- i }  Given two strings, return 1 if x2 is longer. This bubbles the longer names up toward the front of the display. )
    strlen swap strlen  ( i2 i1 )
    >  ( i )
;
: rtn-displaymarker  ( s -- }  Given a 'temp/<marker>' prop, format and display all the exit names in that marker. )
    v_currentprop !  (  )

    ( Okie, get how many exits we need to load. )
    me @ v_currentprop @ "exitname#" strcat getpropstr atoi  ( i )
    ( Remember how many. )
    dup v_howmanyexits !  ( i )
    ( Load all the exits for this marker. )
    begin dup while  ( i )
        me @ v_currentprop @ "exitname#/" strcat  ( i d s )
        3 pick intostr strcat getpropstr  ( i sn )
        swap  ( sn i )
    1 - repeat pop v_howmanyexits @  ( sn..s1 n )

    ( Sort. )
    'rtn-sortbylength prog_quicksort call  ( sn..s1 n )

    ( Display. )
    ( Start with a bracket. )
    "[ " v_string !  ( sn..s1 n )
    ( Get the marker. )
    v_currentprop @ v_tempprop @ strlen strcut swap pop  ( sn..s1 n -sm }  -sm=markerbit )
    dup if
        dup strlen 1 - strcut pop  ( sn..s1 n sm }  sm=these exits' marker )
        "/" swap strcat  ( sn..s1 n /sm )
    then  ( sn..s1 n /sm )
    ( Turn the marker into a label. )
    trigger @ "_obvex/name" rot strcat envpropstr swap pop  ( sn..s1 n sl }  sl=label )
    ( If there's no real label, use 'Obvious Exits'. )
    dup not if pop "Obvious Exits" then  ( sn..s1 n sl )
    ( Prepend with enough spaces that the label is v_maxlabellength characters long. )
    "                             " v_maxlabellength @ 3 pick strlen - strcut pop swap strcat  ( sn..s1 n sl' )
    v_string @ swap strcat ": " strcat v_string !  ( sn..s1 n )

    ( Thread the first exit in. )
    v_string @ rot strcat v_string ! 1 -  ( sn..s2 n )
    ( OK, now we have to loopily loop. )
    begin dup while  ( sn..s2 n )
        swap  ( sn..s3 n s2 )
        ( Is the line long enough to add this exit to the current line? )
        dup strlen v_string @ strlen + 4 + v_linelength @ > if  ( sn..s3 n s2 )
            ( Uh-oh, the line would be too long! )

            ( Cap this line off. )
            v_string @ "                                                            " strcat v_linelength @ 1 - strcut pop "]" strcat  ( sn..s3 n s2 s! )
            rtn-color-line  ( sn..s3 n s2 s!' )
            ansi_tell  ( sn..s3 n s2 )

            ( Start a new line to put s2 in. )
            "[                              " v_maxlabellength @ 4 + strcut pop  ( sn..s3 n s2 s! }  s!=the new v_string )
            swap strcat  ( sn..s3 n s!' )
            v_string !
        else  ( sn..s3 n s2 )
            ( OK, we can add that. )
            v_string @ ", " strcat swap strcat v_string !  ( sn..s3 n )
        then  ( sn..s3 n )
    1 - repeat pop  (  )

    ( OK, cap this last v_string off and notify. )
    v_string @ "                                                            " strcat v_linelength @ 1 - strcut pop "]" strcat  ( s! )
    rtn-color-line  ( s!' )
    ansi_tell  (  )
;

: main  ( -- )

    ( Set some variables we need whether or not we have any exits to display. )
    ( Well, we don't know how long the first label will be, so... )
    0 v_maxlabellength !  (  )
    ( And how long should a line be, anyhow? )
    "linelength" getprefstr atoi dup not if pop 70 then v_linelength !
    ( And what colors do we use? )
    me @ "_obvex/squb" envpropstr swap pop dup if "~&" swap strcat else pop "~&100" then v_color_squb !
    me @ "_obvex/labl" envpropstr swap pop dup if "~&" swap strcat else pop "~&170" then v_color_labl !
    me @ "_obvex/angb" envpropstr swap pop dup if "~&" swap strcat else pop "~&010" then v_color_angb !
    me @ "_obvex/main" envpropstr swap pop dup if "~&" swap strcat else pop "~&170" then v_color_main !
    me @ "_obvex/norm" envpropstr swap pop dup if "~&" swap strcat else pop "~&070" then v_color_norm !


    ( Do we actually have any exits to display? )
    ( If this first exit is really an exit, we do. )
    trigger @ exits  ( d )
    dup ok?  ( d )
$ifdef Glow
    ( Oh, or if we have some paths, too. )
    trigger @ "path_dir" sysparm propdir? or
    ( Note that, if we have paths and no exits, the 'd' that gets passed all the way down is #-1. But that's OK! )
$endif
    not if  ( d )
        pop  (  )
        ( Put together the 'no exits' line. )
        v_color_squb @ "[ " strcat v_color_labl @ strcat "Obvious Exits:" strcat v_color_norm @ strcat " None.                                                                      " strcat  ( s )
        ( Make it the correct length. )
        v_linelength @ 1 - ansi_strcut pop  ( s )
        ( Add the closing square bracket. )
        v_color_squb @ strcat "]" strcat  ( s )
        ( Tell. )
        ansi_tell
        exit
    then  ( d }  d=first exit )


    ( We do; start. )
    ( Find a place to put temporary stuff. )
    propdir_temp random intostr strcat systime intostr strcat "/" strcat v_tempprop !  ( d }  d=first exit )


    ( Do we use first one or first two exits? )
    ( Get the prop's value. )
    "firstn" getprefstr  ( d s )
    ( Ah, but it should be a number. )
    atoi  ( d i )
    ( 0-2 are valid values. If it's an invalid value, use 0. )
    dup 2 > over 0 < or if pop 0 then  ( d i )
    ( Remember it for later. )
    v_firstn !  ( d }  d=first exit )


    ( OK, load up all the exit names. )
    begin dup ok? while  ( d )

        ( Load up this exit's name. )
        ( Are there multiple names in the exit's name? If not, we do nothing to the name. )
        dup name  ( d s )
        rtn-getexitname  ( d s' )

        ( Find the marker this exit should be listed under, since we have to save the exit name by marker to separate and alphabetize correctly. )
        ( Get the marker. )
        over "_obvex/marker" getpropstr  ( d s' sm }  sm=marker this exit should be saved under )
        ( If it exists, postpend a '/'. )
        dup if "/" swap strcat then  ( d s' sm )

        ( Save this name. )
        me @ v_tempprop @  ( d s' sm dt st }  dt/st=temporary prop to put this exit name in )
        3 pick strcat  ( d s' /sm dt st )
        "/exitname#" strcat  ( d s' /sm dt st )
        ( Get the number of exits we've got set there now. )
        over over over over getpropstr atoi  ( d s' /sm dt st dt st ie }  ie=number of exits under this marker so far )

        ( Wait! We need to keep track of the longest label. Let's do that while we have this marker available. )
        ( Is ie 0? If not, we already accounted for this label. )
        dup not if  ( d s' /sm dt st dt st ie )
            ( Yeah, ie==0. Load its label. )
            trigger @ "_obvex/name"  ( d s' /sm dt st dt st ie dl sl )
            8 rotate strcat  ( d s' dt st dt st ie dl sl' )
            envpropstr swap pop  ( d s' dt st dt st ie sl" }  sl"=this marker's label )
            ( How long is the label? )
            dup if strlen else pop 13 then  ( d s' dt st dt st ie il }  il=length of this marker's label )
            ( Is that longer than the recorded maximum? )
            dup v_maxlabellength @ > if v_maxlabellength ! else pop then  ( d s' dt st dt st ie )
        else 6 rotate pop then  ( sp s' dt st' dt st' ie )

        ( Increment it. )
        1 +  ( d s' dt st dt st ie' )
        ( Save it for later. )
        dup -4 rotate  ( d s' dt st ie' dt st ie' )
        ( Save the new number of exits. )
        intostr setprop  ( d s' dt st ie' )
        ( Add the new number to st, so we get the prop to put the exit name into. )
        intostr "/" swap strcat strcat  ( d s' dt st' )
        ( Set the name to that prop. )
        rot setprop  ( d )

    next repeat pop  (  )


$ifdef Glow
    ( Now load up all the path names. )
    ( Well, where are paths kept? )
    "path_dir" sysparm  ( sd }  sd=propdir where paths are kept )
    ( We'll need to know how many characters to remove from the front of the prop, including a '/' after. )
    dup strlen 1 + v_pathdirlength !  ( sd )
    ( Do that loopy thang. )
    "/" strcat begin trigger @ swap nextprop dup while  ( sp }  sp=current path prop )

        ( Well, strip off the path_dir. )
        dup  ( sp sp )
        v_pathdirlength @ strcut swap pop  ( sp s }  s=path's fullname )

        ( Turn it into an exit name suitable for display. )
        dup rtn-getexitname  ( sp s s' }  s'=path's name suitable for display )

        ( Okie, now add it to the appropriate place. )
        ( Find the marker applicable to this exit. )
        trigger @ "_obvex/marker/" 4 rotate strcat getpropstr  ( sp s' sm }  sm=this exit's marker )
        ( If it's non-null, add a /. )
        dup if "/" swap strcat then  ( sp s' /sm )

        ( OK, so, add it to the appropriate temp prop. )
        me @ v_tempprop @  ( sp s' /sm dt st }  dt/st=temporary prop )
        3 pick strcat  ( sp s' /sm dt st' )
        "/exitname#" strcat  ( sp s' /sm dt st' )
        ( Get the number of exits we have under that marker now. )
        over over over over getpropstr atoi  ( sp s' /sm dt st' dt st' ie }  ie=number of exits in this marker )

        ( Wait! We need to keep track of the longest label. Let's do that while we have this marker available. )
        ( Is ie 0? If not, we already accounted for this label. )
        dup not if  ( sp s' /sm dt st' dt st' ie )
            ( Yeah, ie==0. Load its label. )
            trigger @ "_obvex/name"  ( sp s' /sm dt st' dt st' ie dl sl )
            8 rotate strcat  ( sp s' dt st' dt st' ie dl sl' )
            envpropstr swap pop  ( sp s' dt st' dt st' ie sl" }  sl"=this marker's label )
            ( How long is the label? )
            dup if strlen else pop 13 then  ( sp s' dt st' dt st' ie il }  il=length of this marker's label )
            ( Is that longer than the recorded maximum? )
            dup v_maxlabellength @ > if v_maxlabellength ! else pop then  ( sp s' dt st' dt st' ie )
        else 6 rotate pop then  ( sp s' dt st' dt st' ie )

        ( Increment the number of exits on this marker, and hide it so we can use it again in a moment. )
        1 + dup -4 rotate  ( sp s' dt st' ie' dt st ie' )
        ( Update the number of exits under this marker. )
        intostr setprop  ( sp s' dt st' ie' )
        ( OK, where are we sticking this new exit? )
        intostr "/" swap strcat strcat  ( sp s' dt st" )
        ( Stick it there already! )
        rot setprop  ( sp )

    repeat pop  (  )
$endif


    ( Do the formatting and notification. )
    ( Do the empty marker first. )
    me @ v_tempprop @ "exitname#" strcat getpropstr if
        v_tempprop @ rtn-displaymarker
    then

    ( Erase the empty marker. )
    me @ v_tempprop @ "exitname#" strcat remove_prop  (  )

    ( Do the other markers now. )
    v_tempprop @ begin me @ swap nextprop dup while  ( sp }  sp=prop: "_temp/cityscape/nnnn/<marker>" )
        dup "/" strcat rtn-displaymarker  ( sp )
    repeat pop  (  )


    ( Remove the temporary stuff. }
    me @ propdir_temp dup strlen 1 - strcut pop remove_prop  (  )
;
.
c
q
@set Cityscape2.muf=l
@set Cityscape2.muf=v
@set Cityscape2.muf=w
@set Cityscape2.muf=w2
@register Cityscape2.muf=muf/cityscape
@set #0=_msgmacs/cityscape:{muf:$muf/cityscape,}
@set #0=_msgmacs/obvious-exits:{muf:$muf/cityscape,}
blib #add Cityscape2.muf
A path-aware obvious exits program.
