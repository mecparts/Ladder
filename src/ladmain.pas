{
  Note that this code makes free use of the dreaded GOTO command.
}
VAR
  msecs, bonusTimeTicks, moveInterval, x, y : INTEGER;
  ch : CHAR;
  rockPtr : RockPointerType;

LABEL
  restartGame, restartLevel, newLevel;

BEGIN { MAIN }
  dispensers := NIL;        { initialize our linked lists for dispenser }
  m.Rocks := NIL;           { and rocks }
  lastScore := -1;
  playSpeed := 1;
  ReadDataFile;

restartGame:

  m.LadsRemaining := 5;
  m.Level := 1;
  m.Score := 0;
  levelCycle := 1;
  displayLevel := 1;
  nextNewLad := 100;
  CursOn;
  Randomize;
  MainMenu;
  moveInterval := ReadmsWait[playSpeed];
  ClrScr;
  CursOff;

newLevel:

  { Load a level and show it }
  LoadMap(ladXY, dispensers, numDispensers);

restartLevel:

  m.RemainingBonusTime := m.InitialBonusTime - 2 * (levelCycle - 1);
  InitActor(lad, ALAD, ladXY);
  DisperseRocks;

  { Show the initial map on screen }
  DrawMap;
  msecs := 0;
  bonusTimeTicks := 0;

  WHILE TRUE DO BEGIN

    Delay(1);
    msecs := Succ(msecs);
    IF msecs >= moveInterval THEN BEGIN
      { move the Lad and rocks every X milliseconds }
      msecs := 0;
      bonusTimeTicks := bonusTimeTicks + moveInterval;
      IF bonusTimeticks >= BonusTimeDecInterval THEN BEGIN
        { every second, decrement the bonus time/time remaining value }
        bonusTimeTicks := bonusTimeTicks - BonusTimeDecInterval;;
        m.RemainingBonusTime := Pred(m.RemainingBonusTime);
        GotoXY(74, 21);
        Write(m.RemainingBonusTime : 2);
        IF m.RemainingBonusTime <=0 THEN BEGIN
          { died: do the animation and check if we still have lives left }
          IF LadDeath THEN
            GOTO restartLevel;
          GOTO restartGame;
        END;
      END;

      IF m.AnyRocksPending THEN BEGIN
        { pending rocks? see if it's time to start moving }
        rockPtr := m.Rocks;
        m.AnyRocksPending := FALSE;
        WHILE rockPtr <> NIL DO BEGIN
          IF (rockPtr^.Dir = PENDING) THEN
            IF (Random(10) = 0) THEN
              rockPtr^.DirRequest := FALLING
            ELSE
              m.AnyRocksPending := TRUE;
          rockPtr := rockPtr^.Next;
        END;
      END;

      { Move the lad according to players wishes }
      IF (lad.Dir <> STOPPED) OR (lad.DirRequest <> NONE) THEN BEGIN
        x := lad.X; y := lad.Y;
        GotoXY(x, y); Write(m.Field[y][x]);
        MoveActor(lad);
        GotoXY(lad.X, lad.Y); Write(lad.Ch);
        IF (x <> lad.X) AND (y = lad.Y) THEN BEGIN
          { get rid of disappearing flooring }
          IF m.Field[y + 1][x] = '-' THEN BEGIN
            m.Field[y + 1][x] := ' ';
            GotoXY(x, y + 1); Write(' ');
          END;
        END;

        CASE m.Field[lad.Y][lad.X] OF
        
          '$' : BEGIN    { at the Gold: level done }
            UpdateScore(ScoreMoney);
            displayLevel := Succ(displayLevel);
            m.Level := Succ(m.Level);
            IF m.Level > levelCycle + 1 THEN BEGIN
              { done with current cycle, recycle to 1st level }
              levelCycle := SUCC(levelCycle);
              m.Level := 1;
              IF levelCycle > NumCycles THEN BEGIN
                { finished last cycle, end the game unconditionally }
                { TODO: what happened in the original game??? }
                m.LadsRemaining := 1;
                IF LadDeath THEN
                  GOTO restartGame;
              END;
            END;
            GOTO newLevel;
          END;

          '^': BEGIN    { death by fire }
            IF LadDeath THEN
              GOTO restartLevel;
            GOTO restartGame;
          END;

          '&': BEGIN
            { found a statue, adjust the score, remove the statue }
            UpdateScore(ScoreStatue);
            m.Field[lad.Y][lad.X] := ' ';
          END;

          '.': BEGIN  {trampoline: choose a random direction }
            CASE Random(5) OF
              0: BEGIN
                lad.Dir := LEFT;
                lad.DirRequest := NONE;
                lad.JumpStep := 0;
              END;
              1: BEGIN
                lad.Dir := RIGHT;
                lad.DirRequest := NONE;
                lad.JumpStep := 0;
              END;
              2: BEGIN
                lad.Dir := JUMPUP;
                lad.DirRequest := STOPPED;
                lad.JumpStep := 1;
              END;
              3: BEGIN
                lad.Dir := JUMPLEFT;
                lad.DirRequest := LEFT;
                lad.JumpStep := 1;
              END;
              4: BEGIN
                lad.Dir := JUMPRIGHT;
                lad.DirRequest := RIGHT;
                lad.JumpStep := 1;
              END;
            END;
          END;
        END;
      END; { of Lad movement handler -------------------------- }

      { Move the rock(s) }
      rockPtr := m.Rocks;
      WHILE rockPtr <> NIL DO BEGIN
        { Don't draw the rock if it's pending }
        IF rockPtr^.Dir <> PENDING THEN BEGIN
          IF Collision(rockPtr) THEN
            IF LadDeath THEN
              GOTO restartLevel
            ELSE
              GOTO restartGame;
          x := rockPtr^.X;
          y := rockPtr^.Y;
          GotoXY(x, y);
          Write(m.Field[y][x]);
        END;
        MoveActor(rockPtr^);
        { Don't draw the rock if it's pending }
        IF rockPtr^.Dir <> PENDING THEN BEGIN
          IF Collision(rockPtr) THEN
            IF LadDeath THEN
              GOTO restartlevel
            ELSE
              GOTO restartGame;
          GotoXY(rockPtr^.X, rockPtr^.Y);
          Write(rockPtr^.Ch);
        END;
        rockPtr := rockPtr^.Next;
      END; { of rock movement handler ------------------------- }
      { end of tick handler =================================== }
    END;
    IF KeyPressed THEN BEGIN
      Read(Kbd, ch);
      ch := UpCase(ch);
      IF ch = leftKey THEN BEGIN
        lad.DirRequest := LEFT
      END ELSE IF ch = rightKey THEN BEGIN
        lad.DirRequest := RIGHT
      END ELSE IF ch = upKey THEN BEGIN
        lad.DirRequest := UP
      END ELSE IF ch = downKey THEN BEGIN
        lad.DirRequest := DOWN
      END ELSE IF ch = ' ' THEN BEGIN
        lad.DirRequest := JUMP;
      END ELSE IF ch = #$1B THEN BEGIN
        CursOn;
        GotoXY(1, 23); Write('Type RETURN to continue: ');
        REPEAT
          WHILE NOT KeyPressed DO;
          Read(Kbd, ch);
        UNTIL ch IN [#$0D, #$03];
        IF ch = #$03 THEN  { ^C goes back to main menu }
          GOTO restartGame;
        GotoXY(1, 23); ClrEOL;
        CursOff;
      END ELSE IF ch = #$03 THEN BEGIN
        GOTO restartGame
      END ELSE BEGIN
        lad.DirRequest := STOPPED
      END;
    END; { of keypress handler ================================ }
  END;
END.

