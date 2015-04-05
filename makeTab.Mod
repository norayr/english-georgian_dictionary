MODULE makeTab;
IMPORT Out := Console, Files;

CONST input = "lexicon-utf8.txt";
start = 164; (* first word position *)
end = 622016; (* after last word *)

PROCEDURE readTill(VAR r : Files.Rider; ch : CHAR);
VAR s : CHAR;
BEGIN
   REPEAT 
      Files.Read(r, s);
      IF s >= 20X THEN
         IF s # ch THEN Out.Char(s) END
      END
   UNTIL ch = s;
END readTill;

PROCEDURE readTill0(VAR r : Files.Rider; ch : CHAR; VAR eol : BOOLEAN);
VAR s : CHAR;
BEGIN
   REPEAT 
      Files.Read(r, s);
      IF s # ch THEN Out.Char(s) END;
      IF s = 0AX THEN
         Files.Read(r, s);
	 IF (ORD(s) < 128) & (s # '(') THEN 
	    Out.Char(0AX); Out.Char(s); eol := TRUE;
	 ELSE
            Out.Char(' '); Out.Char(s); readTill0(r, ch, eol);
	 END
      END
   UNTIL eol(*(ch = s) OR r.eof*);
END readTill0;


PROCEDURE readTillNot(VAR r : Files.Rider; ch : CHAR);
VAR s : CHAR;
BEGIN
   REPEAT 
      Files.Read(r, s)
   UNTIL ch # s;
      Out.Char(s)
END readTillNot;


PROCEDURE make;
VAR 
    f : Files.File;
    r : Files.Rider;
 length, pos: LONGINT;
 ch : CHAR;
 eol: BOOLEAN;
BEGIN
   f := Files.Old(input);
   IF f # NIL THEN
      Files.Set(r, f, 0(*start*));
      length := Files.Length(f);
      REPEAT
         (* expect english word *)
	 readTill(r, ' ');
         Out.Char(09X); (* put tab *)
	 (* expect georgian translation*)
	 readTillNot(r, ' ');
	 eol := FALSE; readTill0(r, 0AX, eol);
         pos := Files.Pos(r);
      UNTIL (pos >= length)(* OR r.eof*);
   ELSE
      Out.String("input file not found."); Out.Ln;
   END
END make;

BEGIN
make;

END makeTab.
