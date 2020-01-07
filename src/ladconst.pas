CONST
  Version = '1.31TP';
  DataFileName = 'LADDER.DAT';
  ConfigFileName = 'LADCONF.COM';
  NumHighScores = 5;           { # of stored high scores }
  DataFileStrLength = 31;      { # chars in data file terminal config strings }
  DataFileNameLength = 29;     { # chars in high score names }
  CursOffStr = #$1B'[?25l';    { turn cursor off string }
  CursOnStr = #$1B'[?25h';     { turn cursor on string }
  NumPlaySpeeds = 5;           { # of different playing speeds }
  BonusTimeDecInterval = 1000; { decrement bonus time every second }

  NumLevels = 7;               { # of distinct levels }
  NumCycles = 6;               { # of level cycles, 1 less than # of distinct levels }
  LevelRows = 20;              { # of rows in a level map }
  LevelCols = 79;              { # of chars in a level map }
  MaxDispensers = 3;           { max # of rock dispensers on a level }

  JumpsLen = 6;                { max # of positions in a jump sequence }


