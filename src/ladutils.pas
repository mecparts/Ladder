{
  Some terminal routines not handled by Turbo Pascal.
  
  CursOff: turn the cursor off (set the string in LADCONST.PAS)
  CursOn: turn the cursor on (set the string in LADCONST.PAS)
  Beep: ring the terminal bell
}

PROCEDURE CursOff;
BEGIN
  Write(CursOffStr);
END;

PROCEDURE CursOn;
BEGIN
  Write(CursOnStr);
END;

PROCEDURE Beep;
BEGIN
  IF sound THEN
    Write(#7);
END;

