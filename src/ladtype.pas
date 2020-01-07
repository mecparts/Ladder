TYPE
  Str80Type = STRING[80];
  ScoreType = (ScoreReset, ScoreRock, ScoreStatue, ScoreMoney);

  NameStringType = STRING[20];
  LayoutType = ARRAY[1..LevelRows] OF ARRAY[1..LevelCols] OF CHAR;
  LevelType = RECORD
    Name : NameStringType;
    InitialBonusTime : INTEGER;
    Rocks : INTEGER;
    Layout : LayoutType;
  END;

  { The Action constants define what the Actor currently is, }
  { or is requested to be, doing }
  ActionType = (
    PENDING,
    NONE,
    STOPPED,
    UP,
    UPRIGHT,
    RIGHT,
    DOWNRIGHT,
    DOWN,
    DOWNLEFT,
    LEFT,
    UPLEFT,
    FALLING,
    JUMP, { Generic jump set by keyhandler }
    JUMPRIGHT,
    JUMPUP,
    JUMPLEFT,
    ACTIONEND
  );

  ActionArrayType = ARRAY[1..JumpsLen] OF ActionType;

  KindType = ( ALAD, AROCK );

  RockPointerType = ^ActorType;
  { The Actor struct holds info about an actor ie, the Lad or a Rock }
  ActorType = RECORD
    AType : KindType;
    X,Y : INTEGER;
    Ch : CHAR;
    Dir, DirRequest : ActionType;
    JumpStep : INTEGER;
    Next : RockPointerType;
  END;

  { The MapData hold all info about a map }
  MapDataType = RECORD
    Name : NameStringType;
    Field : LayoutType;
    LadsRemaining : INTEGER;
    NumRocks : INTEGER;
    Rocks : RockPointerType;
    AnyRocksPending : BOOLEAN;
    Level : INTEGER;
    Score : INTEGER;
    InitialBonusTime : INTEGER;
    RemainingBonusTime : INTEGER;
    ScoreText : Str80type;
  END;

  XYtype = RECORD
    x, y : INTEGER;
  END;

  DispenserPointerType = ^DispenserType;
  DispenserType = RECORD
    xy : XYtype;
    next : DispenserPointerType;
  END;

  { layout of LADDER.DAT data file }
  DataFileType = RECORD
    TerminalName : STRING[DataFileStrLength];
    MoveCsrPrefix : STRING[DataFileStrLength];
    MoveCsrSeparator : STRING[DataFileStrLength];
    MoveCsrSuffix : STRING[DataFileStrLength];
    UnkEscSeq : STRING[DataFileStrLength]; { not sure what this is... initialization? }
    ClrScrStr : STRING[DataFileStrLength];
    Flags : ARRAY[0..DataFileStrLength] OF CHAR;
    Keys : ARRAY[0..DataFileStrLength] OF CHAR;
    Highs : ARRAY[1..NumHighScores] OF ARRAY[0..DataFileStrLength] OF BYTE;
    Unused1 : ARRAY[0..DataFileStrLength] OF BYTE;
    Unused2 : ARRAY[0..DataFileStrLength] OF BYTE; { padding to next 128 bytes }
    Unused3 : ARRAY[0..DataFileStrLength] OF BYTE;
  END;

  HighScoreType = RECORD
    Score : INTEGER;
    Name : STRING[DataFileNameLength];
  END;

