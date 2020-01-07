{
 ReverseDirection makes the actor to go in the opposite direction,
 it only works when the actor is moving left or right
}
PROCEDURE ReverseDirection(VAR a : ActorType);
BEGIN
  CASE a.Dir OF
    LEFT : a.Dir := RIGHT;
    RIGHT : a.Dir := LEFT;
  END;
END;

{
  OnSolid returns true if standing on something solid i.e. Floor,
  Disappearing floor or a Ladder
}
FUNCTION OnSolid(a : ActorType) : BOOLEAN;
BEGIN
  OnSolid := (m.Field[a.Y + 1][a.X] IN ['=', '-', 'H', '|'])
    OR (m.Field[a.Y][a.X] = 'H');
END;

FUNCTION EmptySpace(x, y : INTEGER) : BOOLEAN;
BEGIN
  EmptySpace := (x < 1) OR (x > LevelCols) OR NOT (m.Field[y][x] IN ['|', '=']);
END;

{
  AboveLadder returns true when the actor is a above a Ladder
}
FUNCTION AboveLadder(a : ActorType) : BOOLEAN;
BEGIN
  AboveLadder := m.Field[a.Y + 1][a.X] = 'H';
END;

{
 OnEater returns true when the actor is standing on a Eater
}
FUNCTION OnEater(a : ActorType) : BOOLEAN;
BEGIN
  OnEater := m.Field[a.Y][a.X] = '*';
END;

{
  ClampToPlayfield makes sure that if the actor tries to walk or jump off
  the playfield edges the actor stays inside the playfield and starts falling
}
PROCEDURE ClampToPlayfield(VAR a : ActorType);
BEGIN
  IF a.Dir IN [LEFT, JUMPLEFT] THEN BEGIN
    IF a.X < 1 THEN BEGIN
      a.X := 1;
      a.Dir := STOPPED;
      a.DirRequest := NONE;
    END;
  END;

  IF a.Dir IN [RIGHT, JUMPRIGHT] THEN BEGIN
    IF a.X > LevelCols THEN BEGIN
      a.X := LevelCols;
      a.Dir := STOPPED;
      a.DirRequest := NONE;
    END;
  END;
END;

{
 InitActor set the fields of an Actor type to reasonable
 initial values
}
PROCEDURE InitActor(VAR a : ActorType; t : KindType; xy : XYtype);
BEGIN
  a.AType := t;
  a.X := xy.x;
  a.Y := xy.y;
  a.Ch := 'X';
  a.JumpStep := 0;
  CASE t OF
    ALAD:
      BEGIN
        a.Ch := 'g';
        a.Dir := STOPPED;
        a.DirRequest := NONE;
      END;
    AROCK:
      BEGIN
        a.Ch := 'o';
        a.Dir := PENDING;
        a.DirRequest := NONE;
      END;
  END;
END;

{
  Set the Lad's character based on their current direction
}
PROCEDURE UpdateLadChar(VAR a : ActorType);
BEGIN
  WITH a DO
    CASE Dir OF
      STOPPED:           Ch := 'g';
      RIGHT, JUMPRIGHT:  Ch := 'p';
      LEFT, JUMPLEFT:    Ch := 'q';
      FALLING:           Ch := 'b';
      UP, DOWN:          Ch := 'p';
      JUMP:
        CASE a.DirRequest OF
          NONE, STOPPED:    Ch := 'g';
          RIGHT, JUMPRIGHT: Ch := 'p';
          LEFT, JUMPLEFT:   Ch := 'q';
        END;
    END;
END;

{
  Update an actor's direction to the latest's request
}
PROCEDURE UpdateDir(VAR a : ActorType);
BEGIN
  a.Dir := a.DirRequest;
  a.DirRequest := NONE;
END;

{
  MoveActor handles the movements of an Actor
}
PROCEDURE MoveActor(VAR a : ActorType);
LABEL
  loopAgain;
VAR
  jd : ActionType;
  i : INTEGER;
  dispenser : DispenserPointerType;
BEGIN

loopAgain: { If just started falling we need to retest all conditions }

  { A STONE can only be LEFT/RIGHT/DOWN/FALLING or PENDING }
  IF a.AType = AROCK THEN BEGIN
    IF (a.Dir = PENDING) AND (a.DirRequest = NONE) THEN
      EXIT;

    { If stopped select a random direction }
    IF a.Dir = STOPPED THEN BEGIN
      CASE Random(2) OF
        0: IF (a.X > 1) AND EmptySpace(a.X - 1, a.Y) THEN
             a.DirRequest := LEFT
           ELSE
             a.DirRequest := RIGHT;
        1: IF (a.X < LevelCols) AND EmptySpace(a.X + 1, a.Y) THEN
             a.DirRequest := RIGHT
           ELSE
             a.DirRequest := LEFT;
      END;
    END;

    { Just reverse direction if at the playfield edge }
    IF (a.X = 1) OR (a.X = LevelCols) THEN
      ReverseDirection(a);

    { Start to fall if not on solid ground }
    IF (a.Dir <> FALLING) AND NOT OnSolid(a) THEN
      a.DirRequest := FALLING;

    { If Der rock just rolled over the top of a ladder then randomize direction }
    IF AboveLadder(a) AND (a.Dir IN [LEFT, RIGHT]) THEN
      CASE Random(4) OF
        0: a.DirRequest := LEFT;
        1: a.DirRequest := RIGHT;
        ELSE a.DirRequest := DOWN;
      END;

    { If on an Eater kill the stone }
    IF OnEater(a) THEN BEGIN
      dispenser := dispensers;
      IF numDispensers > 1 THEN BEGIN
        FOR i := 1 TO Random(numDispensers) DO
          dispenser := dispenser^.next;
      END;
      InitActor(a, AROCK, dispenser^.xy);
      m.AnyRocksPending := TRUE;
    END;
  END; { of stone only handling --------------------- }

  { If stopped or going left or going right and     }
  { request to do something else, then try to do it }
  IF (a.DirRequest <> NONE) THEN BEGIN
    CASE a.Dir OF
      STOPPED, PENDING:
        IF a.DirRequest IN [LEFT, RIGHT, UP, DOWN, FALLING] THEN
          UpdateDir(a);

      JUMPUP:
        IF a.DirRequest = LEFT THEN
          a.Dir := JUMPLEFT
        ELSE IF a.DirRequest = RIGHT THEN
          a.Dir := JUMPRIGHT;

      RIGHT:
        IF a.DirRequest IN [LEFT, STOPPED] THEN
          UpdateDir(a);

      LEFT:
        IF a.DirRequest IN [RIGHT, STOPPED] THEN
          UpdateDir(a);

      UP, DOWN:
        IF a.DirRequest IN [STOPPED, UP, DOWN, RIGHT, LEFT] THEN
          UpdateDir(a);

      JUMPUP:
        IF a.DirRequest = LEFT THEN
          a.Dir := JUMPLEFT
        ELSE
          a.Dir := JUMPRIGHT;

      JUMPRIGHT, JUMPLEFT:
        IF a.DirRequest = STOPPED THEN
          UpdateDir(a);

      PENDING:
        UpdateDir(a);

    END;
  END;

  { Handle starting of jumps }
  IF (a.DirRequest = JUMP) THEN BEGIN
    IF OnSolid(a) THEN BEGIN
      CASE a.Dir OF

        STOPPED, FALLING: BEGIN
          a.DirRequest := STOPPED;
          a.Dir := JUMPUP;
          a.JumpStep := 1;
        END;

        LEFT: BEGIN
          a.DirRequest := a.Dir;
          a.Dir := JUMPLEFT;
          a.JumpStep := 1;
        END;

        JUMPLEFT: BEGIN
          a.DirRequest := LEFT;
          a.Dir := JUMPLEFT;
          a.JumpStep := 1;
        END;

        RIGHT: BEGIN
          a.DirRequest := a.Dir;
          a.Dir := JUMPRIGHT;
          a.JumpStep := 1;
        END;

        JUMPRIGHT: BEGIN
          a.DirRequest := RIGHT;
          a.Dir := JumpRIGHT;
          a.JumpStep := 1;
        END;
      END
    END ELSE BEGIN
      CASE a.Dir OF
        JUMPUP, FALLING: a.DirRequest := STOPPED;
        JUMPRIGHT:       a.DirRequest := RIGHT;
        JUMPLEFT:        a.DirRequest := LEFT;
      END;
    END;
  END ELSE IF (a.DirRequest = UP) AND (m.Field[a.Y][a.X] = 'H') THEN BEGIN
    { If at a ladder and want to go up }
    a.Dir := UP;
    a.DirRequest := NONE;
  END ELSE IF(a.DirRequest = DOWN) AND
    ((m.Field[a.Y][a.X] = 'H') OR (m.Field[a.Y + 1][a.X] = 'H')) THEN BEGIN
    a.Dir := DOWN;
    a.DirRequest := NONE;
  END;

  CASE a.Dir OF

    JUMPUP, JUMPLEFT, JUMPRIGHT: BEGIN
      { Do the jumping }
      jd := jumpPaths[a.Dir, a.JumpStep];
      IF (a.X + dirs[jd].x >= 1) AND (a.X + dirs[jd].x <= LevelCols) THEN BEGIN
        CASE m.Field[a.Y + dirs[jd].y][a.X + dirs[jd].x] OF

          '=', '|', '-' : BEGIN
            { If bumped into something try falling }
            IF OnSolid(a) THEN BEGIN
              a.Dir := a.DirRequest;
              a.DirRequest := NONE;
            END ELSE BEGIN
              CASE a.Dir OF
                JUMPUP:    a.DirRequest := STOPPED;
                JUMPRIGHT: a.DirRequest := RIGHT;
                JUMPLEFT:  a.DirRequest := LEFT;
              END;
              a.Dir := FALLING;
            END;
            a.JumpStep := 0;
          END;

          'H': BEGIN { Jumping onto a ladder }
            a.Y := a.Y + dirs[jd].y;
            a.X := a.X + dirs[jd].x;
            a.Dir := STOPPED;
            a.DirRequest := NONE;
            a.JumpStep := 0;
          END;

          ELSE BEGIN
            { Just jumping in air }
            a.X := a.X + dirs[jd].x;
            a.Y := a.Y + dirs[jd].y;
            a.JumpStep := SUCC(a.JumpStep);
            IF (a.JumpStep > JumpsLen) OR (jumpPaths[a.Dir][a.JumpStep] = ACTIONEND) THEN BEGIN
              UpdateDir(a);
              a.JumpStep := 0;
            END;
          END;
        END;
      END ELSE BEGIN
        IF OnSolid(a) THEN BEGIN
          a.Dir := a.DirRequest;
          a.DirRequest := NONE;
        END ELSE BEGIN
          a.Dir := FALLING;
          a.DirRequest := STOPPED;
          a.JumpStep := 0;
        END;
      END;
    END;

    STOPPED:
      IF NOT OnSolid(a) THEN
        a.Dir := FALLING;

    FALLING: BEGIN
      { If falling then continue doing that until not in free space anymore, }
      { then continue the previous direction (if any)                        }
      IF OnSolid(a) THEN
        IF a.DirRequest = NONE THEN
          a.DirRequest := STOPPED
        ELSE
          a.Dir := a.DirRequest
      ELSE
        a.Y := Succ(a.Y);
    END;

    UP:
      { Climb up until ladder is no more }
      IF m.Field[a.Y - 1][a.X] IN ['H', '&', '$'] THEN
        a.Y := Pred(a.Y)
      ELSE
        a.Dir := STOPPED;

    DOWN:
      { Climb down until ladder is no more }
      IF a.Dir = DOWN THEN
        IF m.Field[a.Y + 1][a.X] IN ['H', '&', '$', ' ', '^', '.'] THEN
          a.Y := Succ(a.Y)
        ELSE
          a.Dir := STOPPED;

    LEFT: BEGIN
      { Stepped out into the void? Then start falling, }
      { but remember the previous direction }
      IF NOT OnSolid(a) THEN BEGIN
        a.DirRequest := a.Dir;
        a.Dir := FALLING;
        GOTO loopAgain;
      END;
      IF EmptySpace(a.X - 1, a.Y) THEN
        a.X := Pred(a.X)
      ELSE
        a.DirRequest := STOPPED;
    END;

    RIGHT: BEGIN
      { Stepped out into the void? Then start falling, }
      { but remember the previous direction }
      IF NOT OnSolid(a) THEN BEGIN
        a.DirRequest := a.Dir;
        a.Dir := FALLING;
        GOTO loopAgain;
      END;
      IF EmptySpace(a.X + 1, a.Y) THEN
        a.X := Succ(a.X)
      ELSE
        a.DirRequest := STOPPED;
    END;
  END;

  { Don't allow actor to end up outside of the playfield }
  ClampToPlayfield(a);
  IF a.AType = ALAD THEN
    UpdateLadChar(a);
END;

