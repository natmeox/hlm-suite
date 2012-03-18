@program quellwarn.muf
1 1000 d
i
( quellwarn.muf by Natasha@HLM
  Warns wizards that they're unquelled.

  Thrust into the public domain this First of November, 2002.
)
$iflib $lib/dotcom $include $lib/dotcom $endif
$def val_delay 300 (five minutes)
: main  ( -- )
    background

    { #-1 begin #-1 "" "pw" findnext dup ok? while
        dup
    repeat pop }list var! wizards

    0 array_make var! warned
    1 var! delay

    begin 1 while
        delay @ sleep

        0 array_make warned !
        wizards @ foreach swap pop
            dup awake? over "wizard" flag? and if  ( db )

                ( Warn. )
                dup "You are unquelled." .notifywarn  ( db )
                warned @ array_appenditem warned !  (  )

            else pop then  (  )
        repeat  (  )

        ( Did we warn during this round? )
        warned @ if

            ( Yes. Delay the next scan. )
            val_delay delay !

$iflib $lib/dotcom
            warned @  ( arr )
            dup array_count 1 = if
                0 array_getitem "\[[1m%D is unquelled." fmtstring
            else
                { swap foreach swap pop name repeat }list
                " and " array_join
                "\[[1m%s are unquelled." fmtstring
            then
            "WizChat" dotcom-say  (  )
$endif
        else
            1 delay !
        then  (  )
    repeat  (  )
;
.
c
q
@set quellw=a
@chown quellw=hlm
