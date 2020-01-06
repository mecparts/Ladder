PROCEDURE Instructions;
BEGIN
  ClrScr;
  WriteLN;
  WriteLN('You are a Lad trapped in a maze.  Your mission is is to explore the');
  WriteLN('dark corridors never before seen by human eyes and find hidden');
  WriteLN('treasures and riches');
  WriteLN;
  WriteLN('You control Lad by typing the direction buttons and jumping by');
  WriteLN('typing SPACE.  But beware of the falaling rocks called Der rocks.');
  WriteLN('You must find and grasp the treasures (shown as $) BEFORE the');
  WriteLN('bonus time runs out.');
  WriteLN;
  WriteLN('A new Lad will be awarded for every 10,000 points.');
  WriteLN('Extra points are awarded for touching the gold');
  WriteLN('statues (shown as &).  You will receive the bonus time points');
  WriteLN('that are left when you have finished the level.');
  WriteLN;
  WriteLN('Type an ESCape to pause the egame.');
  WriteLN;
  WriteLN('Remember, there is more than one way to skin a cat. (Chum)');
  WriteLN;
  WriteLN('Good luck Lad.');
  WriteLN;
  WriteLN;
  WriteLN;
  Write('Type RETURN to return to main menu: ');
  Read;
END;

PROCEDURE ConfigureLadder;
VAR
  configPgm : FILE;
  Ok : BOOLEAN;
BEGIN
  {$I-}
  Assign(configPgm, ConfigFileName);
  WriteLN('Linking to configuration program');
  Execute(configPgm);
  Ok := IOresult = 0; { IOresult must be called after failed Execute }
  {$I+}
  WriteLN;
  WriteLN('Unable to link to LADCONF.COM');
  WriteLN('Ladder configuration program missing');
  Halt;
END;

PROCEDURE MainMenu;
VAR
  ch : CHAR;
  insult : BOOLEAN;
  i, msecs : INTEGER;
  configPgm : FILE;
BEGIN
  REPEAT
    ClrScr;
    WriteLN('               LL                     dd       dd');
    WriteLN('               LL                     dd       dd                      tm');
    WriteLN('               LL         aaaa     ddddd    ddddd    eeee   rrrrrrr');
    WriteLN('               LL        aa  aa   dd  dd   dd  dd   ee  ee  rr    rr');
    WriteLN('               LL        aa  aa   dd  dd   dd  dd   eeeeee  rr');
    WriteLN('               LL        aa  aa   dd  dd   dd  dd   ee      rr');
    WriteLN('               LLLLLLLL   aaa aa   ddd dd   ddd dd   eeee   rr');
    WriteLN;
    WriteLN('                                       Version : ', Version);
    WriteLN('(c) 1982, 1983 Yahoo Software          Terminal: ', dataFileContents.TerminalName);
    WriteLN('10970 Ashton Ave.  Suite 312           Play speed: ', playSpeed);
    Write(  'Los Angeles, Ca  90024                 ');
    WriteLN('Up = ', upKey, '  Down = ',downKey ,'  Left = ', leftKey, '  Right = ', rightKey);
    WriteLN('                                       Jump = Space   Stop = Other');
    WriteLN;
    WriteLN('P = Play game                          High Scores');
    WriteLN('L = Change level of difficulty');
    WriteLN('C = Configure Ladder');
    WriteLN('I = Instructions');
    WriteLN('E = Exit Ladder');
    WriteLN;
    WriteLN;
    Write('Enter one of the above: ');
    { show high scores }
    FOR i := 1 TO NumHighScores DO BEGIN
      GotoXY(40, i + 15);
      Write(i, ') ');
      IF highScores[i].Score <> 0 THEN
        Write(highScores[i].Score:4, '00  ', highScores[i].Name);
    END;
    IF lastScore <> -1 THEN BEGIN
      GotoXY(40, 22);
      Write('Last Score: ',lastScore,'00');
    END;
    GotoXY(25, 22);

    { randomly prompt the user to get a move on }
    insult := FALSE;
    msecs := 0;
    REPEAT
      Delay(1);
      msecs := Succ(msecs);
      IF msecs >= 1000 THEN BEGIN
        msecs := 0;
        IF insults THEN BEGIN
          IF insult THEN BEGIN
            GotoXY(1, 24);
            ClrEol;
            insult := FALSE;
            GotoXY(25, 22);
          END ELSE BEGIN
            i := Random(10);
            IF i > 7 THEN BEGIN
              insult := TRUE;
              GotoXY(1, 24);
              IF i = 8 THEN
                Write('You eat quiche!')
              ELSE
                Write('Come on, we don''t have all day!');
              GotoXY(25, 22);
            END;
          END;
        END;
      END;

      ch := #0;
      IF KeyPressed THEN BEGIN
        Read(Kbd, ch);
        ch := UpCase(ch);
        IF ch = 'L' THEN BEGIN { change playing speed }
          playSpeed := SUCC(playSpeed MOD NumPlaySpeeds);
          GotoXY(52, 11); Write(playSpeed);
          GotoXY(25, 22);
        END ELSE IF ch = 'I' THEN
          Instructions;
      END;
    UNTIL ch IN ['P','C','I','E'];
  UNTIL ch in ['P', 'C', 'E'];
  IF ch = 'E' THEN BEGIN
    Write('Exiting...');
    GotoXY(1, 24);
    ClrEOL;
    GotoXY(1, 23);
    Halt;
  END ELSE IF ch = 'C' THEN BEGIN { run configuration program }
    GotoXY(1, 23);
    ConfigureLadder;
  END;
END;


{
  Read the LADDER.DAT file. This is the same file used in the original
  game. We don't use the cursor control stuff (that's handled by Turbo
  Pascal, but do use the control keys, flags and high scores.
  
  I'm sure this code could be better, but it does the job.
}
PROCEDURE ReadDataFile;
VAR
  dataFile,configPgm : FILE;
  i, j : INTEGER;
BEGIN
  {$I-}
  Assign(dataFile, DataFileName);
  Reset(dataFile);
  IF IOresult <> 0 THEN BEGIN
    ConfigureLadder;
  END;
  BlockRead(dataFile, dataFileContents, SizeOf(dataFileContents) DIV 128);
  IF IOresult <> 0 THEN BEGIN
    WriteLN('Ladder not configred');
    WriteLN;
    ConfigureLadder;
  END;
  WITH dataFileContents DO BEGIN
    sound := Flags[0] = 'Y';
    insults := Flags[1] = 'Y';
    downKey := Keys[0];
    leftKey := Keys[1];
    rightKey := Keys[2];
    upKey := Keys[3];
    FOR i := 1 TO NumHighScores DO BEGIN
      highScores[i].Name[0] := CHAR(Highs[i][0]);
      IF Highs[i][0] = 0 THEN
        highScores[i].Score := 0
      ELSE
        highScores[i].Score := Highs[i][1] OR (Highs[i][2] SHL 8);
      FOR j := 1 TO Highs[i][0] DO
        highScores[i].Name[j] := CHAR(Highs[i][j + 2]);
    END;
  END;
  Close(dataFile);
  {$I+}
END;

{
  Update the high scores in LADDER.DAT. See the comments in
  ReadDataFile.
}
PROCEDURE WriteDataFile;
VAR
  dataFile : FILE;
  i, j : INTEGER;
BEGIN
  {$I-}
  Assign(dataFile, DataFileName);
  Reset(dataFile);
  IF IOresult <> 0 THEN BEGIN
    WriteLN('Reset on LADDER.DAT failed');
    Halt;
  END;
  WITH dataFileContents DO BEGIN
    FOR i := 1 TO NumHighScores DO BEGIN
      Highs[i][0] := Length(highScores[i].Name);
      Highs[i][1] := Lo(highScores[i].Score);
      Highs[i][2] := Hi(highScores[i].Score);
      FOR j := 1 TO Highs[i][0] DO
        Highs[i][j + 2] := ORD(highScores[i].Name[j]);
    END;
    BlockWrite(dataFile, dataFileContents, SizeOf(dataFileContents) DIV 128);
    IF IOresult <> 0 THEN BEGIN
      WriteLN('BlockWrite on LADDER.DAT failed');
      Halt;
    END;
  END;
  Close(dataFile);
  {$I+}
END;

{
  kill the lad off in a horrible death of mixed up characters.
}
FUNCTION  LadDeath : BOOLEAN;
CONST
  NumSymbols = 11;
  symbols : ARRAY[1..NumSymbols] OF CHAR = ('p', 'b', 'd', 'q', 'p', 'b', 'd', 'q', '-', '-', '_');
VAR
  i, j : INTEGER;
  name: STRING[DataFileNameLength];
  ch : CHAR;
BEGIN
  FOR i := 1 TO NumSymbols DO BEGIN
    Beep;
    GotoXY(lad.X, lad.Y); Write(symbols[i]);
    Delay(150);
  END;
  m.LadsRemaining := Pred(m.LadsRemaining);
  GotoXY(8, 21); Write(m.ladsRemaining : 2);
  LadDeath := m.LadsRemaining > 0;
  IF m.LadsRemaining <= 0 THEN BEGIN
    FOR i := 1 TO NumHighScores DO BEGIN
      WriteLN(highScores[i].Score);
      IF m.Score >= highScores[i].Score THEN BEGIN
        FOR j := NumHighScores - 1 DOWNTO i DO BEGIN
          highScores[j + 1] := highScores[j];
        END;
        ClrScr;
        GotoXY(10, 7);
        FOR j := 1 TO 7 DO
          Write('YAHOO! ');
        WriteLN;
        WriteLN;
        CASE levelCycle OF
          1 : WriteLN('You really don''t deserve this but...');
          2 : WriteLN('Not bad for a young Lad');
          3 : WriteLN('Amazing!  You rate!!');
          4 : WriteLN('Looks like we have a Lad-Der here');
          5 : WriteLN('Yeah! Now you are a Lad-Wiz!');
          6 : WriteLN('Wow! You are now a Lad-Guru!');
          7 : WriteLN('You are a true Lad-Master!!!');
        END;
        WriteLN;
        While KeyPressed DO
          Read(Kbd, ch);
        Write('Enter your name: ');
        CursOn;
        Read(name);
        CursOff;
        GotoXY(1, 17);
        Write('Updating high scores...');
        highScores[i].Score := m.Score;
        highScores[i].Name := name;
        WriteDataFile;
        EXIT;
      END;
    END;
  END;
END;

PROCEDURE DrawMap;
VAR
  x, y : INTEGER;
  ch : CHAR;
BEGIN
  FOR y := 1 TO LevelRows DO BEGIN
    GotoXY(1, y);
    FOR x := 1 TO LevelCols DO
      Write(m.Field[y][x]);
  END;
  { Draw the lad at rest }
  GotoXY(lad.X, lad.Y); Write('g');
  { Initialize the entire status line }
  GotoXY(1, 21);
  Write('Lads   ',m.LadsRemaining : 2,
        '     Level   ', displayLevel : 2,
        '     Score ', m.Score : 5, '00',
        '                 Bonus time    ', m.RemainingBonusTime : 2, '00');
  GotoXY(1, 23); Write('Get ready!');
  Delay(1000);
  WHILE KeyPressed DO
    Read(Kbd, ch);
  GotoXY(1, 23); Write('          ');
END;

{
  Adjusts the score according to some event.
}
PROCEDURE UpdateScore(scoreEvent : ScoreType);
BEGIN
  CASE scoreEvent OF

    ScoreStatue: BEGIN
      m.Score := m.Score + m.RemainingBonusTime;
      Beep;
    END;

    ScoreReset: m.Score := 0;

    ScoreRock: BEGIN
      m.Score := m.Score + 2;
      Beep;
    END;

    ScoreMoney: BEGIN
      WHILE m.RemainingBonusTime > 0 DO BEGIN
        GotoXY(1, 23); Write('Hooka!'); Beep; Delay(100);
        GotoXY(1, 23); Write('      '); Delay(100);
        m.Score := Succ(m.Score);
        m.RemainingBonusTime := Pred(m.RemainingBonusTime);
        GotoXY(36, 21); Write(m.Score : 5);
        GotoXY(74, 21); Write(m.RemainingBonusTime : 2);
      END;
    END;
  END;
  { give a new lad if over 10,000 points }
  IF m.Score >= nextNewLad THEN BEGIN
    m.ladsRemaining := Succ(m.ladsRemaining);
    nextNewLad := nextNewLad + 100;
    GotoXY(8, 21); Write(m.ladsRemaining : 2);
  END;
  GotoXY(36, 21);
  Write(m.Score : 5);
END;

{
  Check to see if the Lad has collided with, or jumped over a rock.
}
FUNCTION Collision(rockPtr : RockPointerType) : BOOLEAN;
BEGIN
  Collision := FALSE;
  IF lad.X = rockPtr^.X THEN BEGIN
    IF lad.Y = rockPtr^.Y THEN BEGIN
      Collision := TRUE;
    END ELSE IF (lad.Y = rockPtr^.Y - 1) AND
      (m.Field[lad.Y + 1][lad.X] = ' ') THEN BEGIN
      { score for jumping rocks }
      UpdateScore(ScoreRock);
    END ELSE IF (lad.Y = rockPtr^.Y - 2) AND
      (m.Field[lad.Y + 1][lad.X] = ' ') AND
      (m.Field[lad.Y + 2][lad.X] = ' ') THEN BEGIN
      { score for jumping rocks }
      UpdateScore(ScoreRock);
    END;
  END;
END;

{
  Set each rock up in a random dispenser.
}
PROCEDURE DisperseRocks;
VAR
  rockPtr : RockPointerType;
  dispenserPtr : DispenserPointerType;
  i : INTEGER;
BEGIN
  rockPtr := m.Rocks;
  WHILE rockPtr <> NIL DO BEGIN
    dispenserPtr := dispensers;
    IF numDispensers > 1 THEN
      FOR i := 1 TO Random(numDispensers) DO
        dispenserPtr := dispenserPtr^.Next;
    InitActor(rockPtr^, AROCK, dispenserPtr^.xy);
    rockPtr := rockPtr^.Next;
  END;
  m.AnyRocksPending := TRUE;
END;

