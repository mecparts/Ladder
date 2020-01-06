{ LoadMap loads one of the playfields/maps into memory and also }
{ returns the coordinates of the initial Lad, and an array of }
{ coordinates where the dispensers are. }
PROCEDURE LoadMap(VAR lad : XYtype; VAR dispensers : DispenserPointerType; VAR numDispensers : INTEGER);
VAR
  x, y : INTEGER;
  newDispenser : DispenserPointerType;
  dispenserPtr : DispenserPointerType;
  rock1Ptr,rock2Ptr : RockPointerType;
BEGIN
  { get rid of anay previous rock dispensers }
  WHILE dispensers <> NIL DO BEGIN
    dispenserPtr := dispensers^.next;
    DISPOSE(dispensers);
    dispensers := dispenserPtr;
  END;
  IF m.Level > NumLevels THEN BEGIN
    ClrScr;
    WriteLN('Level ', m.Level, ' out of range');
    CursOn;
    Halt;
  END;
  WITH levels[m.Level] DO BEGIN
    m.Name := Name;
    m.InitialBonusTime := InitialBonusTime;
    m.NumRocks := rocks;
    
    { dispose of any previous rocks }
    WHILE m.Rocks <> NIL DO BEGIN
      rock1Ptr := m.Rocks^.Next;
      Dispose(m.Rocks);
      m.Rocks := rock1Ptr;
    END;
    { allocate new rocks }
    FOR x := 1 TO Rocks DO BEGIN
      rock1Ptr := m.Rocks;
      New(rock2Ptr);
      m.Rocks := rock2Ptr;
      m.Rocks^.Next := rock1Ptr;
    END;
    m.AnyRocksPending := TRUE;
  END;
  { Prepare the field to be loaded with a new level }
  FOR y := 1 TO LevelRows DO
    FOR x := 1 TO LevelCols DO
      m.Field[y][x] := ' ';
  dispensers := NIL;
  numDispensers := 0;
  FOR y := 1 TO LevelRows DO
    FOR x := 1 TO LevelCols DO
      CASE levels[m.Level].layout[y][x] OF
        'p':
          BEGIN
            { The lad will be put there by the rendered, so no need to have }
            { it on the map }
            lad.x := x;
            lad.y := y;
          END;
        'V':
          BEGIN
            m.Field[y][x] := 'V';
            NEW(newDispenser);
            newDispenser^.xy.x := x;
            newDispenser^.xy.y := y;
            newDispenser^.next := dispensers;
            dispensers := newDispenser;
            numDispensers := Succ(numDispensers);
          END;
        '.': { TODO - handle the rubber balls }
          m.Field[y][x] := '.'
        ELSE
          m.Field[y][x] := levels[m.Level].layout[y][x];
      END;
END;

