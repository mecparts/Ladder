{ Initialized constants for Ladder }

CONST
  {
    p - The place where the lad starts.
    V - Der Dispenser. Der Rocks roll out of it to squash you flat.
    * - Der Eaters. They eat the Der Rocks but oddly do not harm you in the slightest
    = - Floor. You walk on it.
    H - Ladder. You climb it.
    | - Wall. You can't walk through it. You're not a ghost....yet.
    . - Rubber Ball. It's very bouncy. This difference is, it bounces you.
    $ - Treasure. The lad must get here to finish the level.
    & - Gold Statue. Money!Money!Money!Money!Money!
    ^ - Fire. Turns you into extra crispy bacon.
    - - Disposable Floor. Well, you can walk on it once.
  }
  levels : ARRAY[1..NumLevels] OF LevelType = (
    (
      Name : 'Easy Street';
      InitialBonusTime : 35;
      Rocks : 5;
      Layout : (
        '                                       V                 $                     ',
        '                                                         H                     ',
        '                H                                        H                     ',
        '       =========H==================================================            ',
        '                H                                                              ',
        '                H                                                              ',
        '                H          H                             H                     ',
        '================H==========H==================   ========H=====================',
        '                &          H                             H          |       |  ',
        '                                                         H         Easy Street ',
        '                H                                        H                     ',
        '       =========H==========H=========  =======================                 ',
        '                H                                                              ',
        '                H                                                              ',
        '                H                                        H                     ',
        '======================== ====================== =========H==============       ',
        '                                                         H                     ',
        '                                                         H                     ',
        '*    p                                                   H                    *',
        '==============================================================================='
      )
    ),
    (
      Name : 'Long Island';
      InitialBonusTime : 45;
     Rocks : 8;
      Layout : (
        '                                                                          $    ',
        '                                                                   &      H    ',
        '    H       |V                                                     V|     H    ',
        '====H======================= ========================= ======================  ',
        '    H                                                                          ',
        '    H                                                                          ',
        '    H                    & |                         . .                  H    ',
        '========================== ======  =================== ===================H==  ',
        '                                                                          H    ',
        '                                  |                                       H    ',
        '    H                             |                 .  .                  H    ',
        '====H=====================   ======  ================  ======================  ',
        '    H                                                                          ',
        '    H                      |                                                   ',
        '    H                      |                        .   .                 H    ',
        '=========================  ========    ==============   ==================H==  ',
        '                                                                          H    ',
        '==============                      |                                     H    ',
        ' Long Island |   p         *        |                 *                   H    ',
        '==============================================================================='
      )
    ),
    (
      Name : 'Ghost Town';
      InitialBonusTime : 35;
     Rocks : 5;
      Layout : (
        '                            V               V           V               $      ',
        '                                                                       $$$     ',
        '     p    H                                                    H      $$$$$   H',
        '==========H===                                                =H==============H',
        '          H                                                    H              H',
        '          H                              &                     H              H',
        '     ==============   ====     =    ======    =   ====    =====H=====         H',
        '    G              ^^^    ^^^^^ ^^^^      ^^^^ ^^^    ^^^                     $',
        '    h                                                                 |        ',
        '    o     |                     H                             &       |        ',
        '    s     ======================H============================== ===========    ',
        '    t        &                  H                                              ',
        '                                H                                              ',
        '              |                 H                 H                   H        ',
        '    T         ==================H=================H===================H======= ',
        '    o                                             H                   H        ',
        '    w                                                                 H        ',
        '    n                           ^                                     H        ',
        '*                              ^^^                                    H       *',
        '==============================================================================='
      )
    ),
    (
      Name : 'Tunnel Vision';
      InitialBonusTime : 36;
     Rocks : 5;
      Layout : (
        '                                            V                       V          ',
        '                                                                               ',
        '     H             H                         |                H                ',
        '=====H=====--======H==========================     ===----====H===========     ',
        '     H             H                |&&                       H                ',
        '     H             H                ==================        H                ',
        '     H             H                       tunnel  H          H                ',
        '     H           =======---===----=================H=         H           H    ',
        '     H         |                           vision  H          H           H    ',
        '     H         =========---&      -----============H          H           H    ',
        '     H           H                                 H |        H           H    ',
        '     H           H=========----===----================        H  ==============',
        '                 H                                        &   H                ',
        '                 H                                        |   H                ',
        '====---====      H                                        |   H                ',
        '|         |    ================---===---===================   H                ',
        '|   ===   |                                                   H        H    p  ',
        '|    $    |                                                   H     ===H=======',
        '|*  $$$  *|   *                *       *                     *H       *H       ',
        '==============================================================================='
      )
    ),
    (
      Name : 'Point of No Return';
      InitialBonusTime : 35;
     Rocks : 7;
      Layout : (
        '         $                                                                     ',
        '         H                                                   V                 ',
        '         H                                                                     ',
        '         HHHHHHHHHHHHH     .HHHHHHHHHHHHHH                          H    p     ',
        '         &                   V           H                        ==H==========',
        '                                         H                          H          ',
        '   H                                     H        .                 H          ',
        '===H==============-----------============H====                      H          ',
        '   H                                                      H         H          ',
        '   H                                                 =====H==============      ',
        '   H                                     H                H                    ',
        '   H              &..^^^.....^..^ . ^^   H==---------     H                    ',
        '   H         ============================H    &           H             H      ',
        '   H         ===      ===      ===       H    ---------=================H======',
        '   H                                     H                              H      ',
        '   H                          &          H          &                   H      ',
        '   ==========-------------------------=======----------===================     ',
        '                                                                               ',
        '^^^*         ^^^^^^^^^^^^^^^^^^^^^^^^^*     *^^^^^^^^^^*Point of No Return*^^^^',
        '==============================================================================='
      )
    ),
    (
      Name : 'Bug City';
      InitialBonusTime : 37;
     Rocks : 6;
      Layout : (
        '        Bug City             HHHHHHHH                          V               ',
        '                           HHH      HHH                                        ',
        '   H                                          >mmmmmmmm                        ',
        '   H===============                   ====================          H          ',
        '   H              |=====       \  /         V                  =====H==========',
        '   H                            \/                                  H          ',
        '   H                                        | $                     H          ',
        '   H           H                            | H                     H          ',
        '   H       ====H=======          p          |&H    H                H          ',
        '   H           H             ======================H           ======          ',
        '   H           H      &|                           H                    H      ',
        '   H           H      &|                    H      H     }{        =====H====  ',
        '===H===&       H       =====================H      H                    H      ',
        '               H                            H      H                    H      ',
        '               H                            H      &                    H      ',
        '         ======H===   =======    H    <>    &                           H      ',
        '                                 H==========       =====     =     ============',
        '     }i{                         H                                             ',
        '*                                H                                            *',
        '==============================================================================='
      )
    ),
    (
      Name : 'GangLand';
      InitialBonusTime : 32;
      Rocks : 6;
      Layout : (
        '                    =Gang Land=                             V                  ',
        '                   ==      _  ==                                      .        ',
        '      p    H        |  [] |_| |                  &                    .  H     ',
        '===========H        |     |_| |       H         ===   ===================H     ',
        '      V    H        =============     H======                            H     ',
        '           H                          H                     &            H     ',
        '           H                          H                |    |            H     ',
        '    H      H        ^^^&&^^^ & ^  ^^^ H           H    |    =============H     ',
        '    H======H   =======================H===========H=====          &      H     ',
        '    H                                 H           H    |         &&&     H     ',
        '    H                                 H           H    |        &&&&&    H     ',
        '    H                                 H           H    |    =============H     ',
        '              =====------=================        H    |       $     $         ',
        '                                         |        H    |      $$$   $$$        ',
        '====------===                            |        H    |     $$$$$ $$$$$       ',
        '            |       =                    | =============    ============       ',
        '            |       $                     ^          &                         ',
        '            |^^^^^^^^^^^^^^      $ ^              ======                       ',
        '*                   .      &   ^ H*^                    ^  ^       ^^^^^^^^^^^^',
        '==============================================================================='
      )
    )
  );

  {
    A moving jump is UR/UR/R/R/DR/DR
    or               UL/UL/L/L/DL/DL
    A standing jump is U/U/-/D/D

     ====================
     ----234-----23------
     ---1---5----14------
     --0-----6---05------
     ====================
  }
  jumpPaths : Array[JUMPRIGHT..JUMPLEFT] OF ActionArrayType = (
    (UPRIGHT, UPRIGHT, RIGHT, RIGHT, DOWNRIGHT, DOWNRIGHT),
    (UP, UP, STOPPED, DOWN, DOWN, ACTIONEND),
    (UPLEFT, UPLEFT, LEFT, LEFT, DOWNLEFT, DOWNLEFT)
  );

  dirs : ARRAY[STOPPED..JUMPLEFT] OF XYtype = (
    (x: 0; y: 0), { STOPPED }
    (x: 0; y:-1), { UP }
    (x: 1; y:-1), { UPRIGHT }
    (x: 1; y: 0), { RIGHT }
    (x: 1; y: 1), { DOWNRIGHT }
    (x: 0; y: 1), { DOWN }
    (x:-1; y: 1), { DOWNLEFT }
    (x:-1; y: 0), { LEFT }
    (x:-1; y:-1), { UPLEFT }
    (x: 0; y: 1), { FALLING }
    (x: 0; y: 0), { JUMP }
    (x: 0; y: 0), { JUMPRIGHT }
    (x: 0; y: 0), { JUMPUP }
    (x: 0; y: 0)  { JUMPLEFT }
  );
  
  ReadmsWait : ARRAY [1..NumPlaySpeeds] OF INTEGER = (100, 50, 25, 13, 7);

