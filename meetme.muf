@program cmd-meetme.muf
1 1000 d
i
( cmd-meetme.muf by Natasha@HLM
  A simple, free mjoin/msummon program for Fuzzball 6.

  Invitations are stored on the inviter. For example, if A msummons B without
  a prior invitation, A's _meetme/summon/#B property is set to the current
  time. When X mjoins Y, meetme will look for a prior invitation in Y's
  _meetme/join/#X property; if it's there, X will be moved to Y immediately.
  Otherwise notification takes place.

  There's currently no "meet" command to let the invited party choose whether
  to summon or join. Sorry.


  v1.1  7  July 2002: added $lib/ignore support.
  v1.2  8 March 2004: optionalized $lib/ignore; cleaned up the generalized functions.

  Copyright 2002-2004 Natasha Snunkmeox. Copyright 2002-2004 Here Lie Monsters.

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
$author Natasha Snunkmeox <natmeox@neologasm.org>
$note A simple, free mjoin/msummon program for Fuzzball 6.
$version 1.002

$include $lib/strings

$iflib $lib/alias
    $include $lib/alias
$else
    $include $lib/match
$endif

$iflib $lib/ignore
    $include $lib/ignore
$else
    $def ignores? pop ignoring?
$endif

$ifndef __muckname=HLM
    $def .tellgood .tell
    $def .tellbad .tell
    $def .notifywarn notify
    $def .notifybad notify
    $def .showhelp prog "_help" array_get_proplist me @ 1 array_make array_notify
$endif

$def str_program "meetme" (which $lib/ignore list)
$def prop_invites "_meetme/%s/%d"
$def int_expire 300

: rtn-invited  ( dbInviter dbInvited strMode -- bool }  Has dbInviter summoned dbInvited? )
    prop_invites fmtstring  ( dbInviter strProp )
    over over getpropval dup if 300 + systime > else pop 0 then  ( dbInviter strProp bool )
    dup -4 rotate if pop pop else remove_prop then  ( bool )
;

: rtn-meet  ( db dbMe strMode -- )
    "summon" strcmp if (So strMode is NOT summon, so dbMe is dbMove.) swap then  ( dbMove dbStill )
    location moveto  (  )
;

: rtn-join-summon[ str:done str:asked str:ask str:dowhat str:dontwhat db:who -- ]
    ( Has db summoned me@? )
    me @ dontwhat @ prop_invites fmtstring  ( strInviteProp )
    who @ over getpropval  ( strProp intWhen )
    who @ rot remove_prop  ( intWhen }  Either there wasn't an invite, it's expired, or we accepted it--any way, it's used up. )
    systime int_expire - < if  (  )
        ( No. I'm asking to join db. )

        ( Is db ignoring me@? )
        who @ me @ str_program ignores? if
            "%D is ignoring you." fmtstring .tellbad
            exit
        then

        ( Am I@ ignoring db? )
        me @ who @ str_program ignores? if
            "You are ignoring %D." fmtstring .tellbad
            exit
        then

        ( Record my invitation. )
        me @
        who @ dowhat @ prop_invites fmtstring  ( dbMe strInviteProp )
        systime setprop  (  )

        ( Notify. )
        who @ ask @ fmtstring .tellgood

        me @ dup dup asked @ fmtstring pronoun_sub  ( strMsg )
        who @ swap .notifywarn  (  )
    else
        ( Yes. )
        who @ me @ dowhat @ rtn-meet
        done @ .tellgood
    then  (  )
;

: do-join  ( db -- )
    "Joined." "%D has asked to join you. Type 'msummon %D' to summon %%o." "You ask to join %D." "join" "summon" 6 rotate rtn-join-summon  (  )
;
: do-summon  ( db -- )
    "Summoned." "%D has asked you to join %%o. Type 'mjoin %D' to do so." "You ask %D to join you." "summon" "join" 6 rotate rtn-join-summon  (  )
;

: rtn-cancel-decline[ str:osc str:sc str:noInvite str:dowhat db:who -- ]
    me @ who @  ( dbMe dbWho )
    dowhat @ "cancel" stringcmp if (I@ am declining, so db is the inviter.) swap then  ( dbInviter dbInvited )

    ( Is there a real invite to cancel? )
    over over "join" rtn-invited not if  ( dbInviter dbInvited )
        over over "summon" rtn-invited not if  ( dbInviter dbInvited )
            who @ noInvite @ fmtstring .tellbad  ( dbInviter dbInvited )
            pop pop exit  (  )
        else "join" "summon" then  ( dbInviter dbInvited strNotJs strJs )
    else "summon" "join" then  ( dbInviter dbInvited strNotJs strJs )

    ( Cancel it. )
    4 rotate 4 rotate rot  ( strNotJs dbInviter dbInvited strJs )
    prop_invites fmtstring  ( strNotJs dbInviter strProp )
    remove_prop  ( strNotJs )

    ( Notify me. )
    who @ over who @  ( strNotJs db strNotJs db )
    sc @ fmtstring pronoun_sub  ( strNotJs strMsg )
    .tellgood  ( strNotJs )

    ( Notify other party. )
    me @ swap over  ( dbMe strNotJs dbMe )
    osc @ fmtstring pronoun_sub  ( db strMsg )
    .notifybad  (  )
;
: do-cancel  ( db -- )
    "%D cancels %%p invitation to %s %%o." "You cancel your invitation for %D to %s you." "You have no outstanding invitation to %D to cancel." "cancel" 5 rotate  ( strNoInvite strMode db )
    rtn-cancel-decline
;
: do-decline  ( db -- )
    "%D declines your invitation to %s you." "You decline %D's invitation to %s %%o." "%D has tendered no invitation to decline." "decline" 5 rotate  ( strNoInvite strMode db )
    rtn-cancel-decline
;

: do-help .showhelp ;

$iflib $lib/ignore
: do-ignore   str_program cmd-ignore-add ;
: do-unignore str_program cmd-ignore-del ;
$endif

$define dict_commands {
    ("meetme"  'do-help--but let the handler do it)
    ("meet"     'do-meet)
    "mjoin"    'do-join
    "msummon"  'do-summon
    "mdecline" 'do-decline
    "mcancel"  'do-cancel
}dict $enddef

$define dict_hashcmds {
    "help"     'do-help
$iflib $lib/ignore
    "ignore"   'do-ignore
    "unignore" 'do-unignore
    "!ignore"  'do-unignore
$endif
}dict $enddef

: main  ( str -- )
    ( What? )
    STRparse pop  ( strX strY )
    over if  ( strX strY )
        swap dict_hashcmds over array_getitem  ( strY strX ? )
        dup address? if  ( strY strX adr )
            swap pop execute  (  )
            exit  (  )
        then  ( strY strX ? )
        pop  ( strY strX )
        "I don't know what you mean by '#%s'." fmtstring .tellbad  ( strY )
        pop exit  (  )
    then  ( strX strY )
    swap pop  ( strArg )
    command @ tolower  ( strArg strCmd )

    dict_commands over array_getitem  ( strArg strCmd ? )
    dup address? not if  ( strArg strCmd ? )
        pop pop pop .showhelp exit  (  )
    then  ( strArg strCmd adr )
    swap pop  ( strArg adr )

    ( All other commands take a player argument, so who is strArg? )
$iflib $lib/alias
    me @ rot alias-expand  ( adr arrDb )
    foreach swap pop  ( adr db )
        over execute  ( adr )
    repeat  ( adr )
    pop  (  )
$else
    swap .noisy_pmatch dup ok? not if pop pop exit then  ( adr dbArg )
    swap  ( dbArg adr )
    execute  (  )
$endif
;
.
c
q
@set cmd-meetme.muf=v
@set cmd-meetme.muf=3

lsedit cmd-meetme.muf=_help
.del 1 $
mjoin <name>
msummon <name>

Joins or summons player <name>. If you haven't already been asked to join or summon <name>, they will be notified you asked; they can then use the opposite action to join or summon you. That is:

1. You 'mjoin Widget'. Widget is notified you want to join him.
2. Widget 'msummons <you>'. You are transported to where Widget is.
.format 4=78
.end
