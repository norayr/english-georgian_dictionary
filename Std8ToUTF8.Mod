MODULE Std8ToUTF8;

IMPORT Args, Out := Console, Files, SYSTEM;

TYPE 
     string* = POINTER TO ARRAY OF CHAR;
     uchar* = ARRAY 4 OF CHAR;

     VAR map : ARRAY 255 OF uchar;

PROCEDURE StripNull(VAR str : uchar): string;
VAR pchar : string;
    i, j : INTEGER;
BEGIN
   i := 0;
   REPEAT
      INC(i);
   UNTIL str[i] = 0X;
   NEW(pchar, i+1);
   j := 0;
   REPEAT
      pchar^[j] := str[j];
      INC(j);
   UNTIL j = i;
   RETURN pchar
END StripNull;

PROCEDURE G2U*(ch : CHAR): string;
VAR
    str0 : uchar;
    pch : string;
BEGIN
   str0 := map[ORD(ch)];
   RETURN StripNull(str0);
   (*NEW(pch, 4);
   COPY(str0, pch^);
   RETURN pch;*)
END G2U;

PROCEDURE ShowHelp;
BEGIN
   Out.String("Georgian Std8(Geo, SP) encoding to UTF-8 converter"); Out.Ln;
   Out.Ln;
   Out.String("Usage: Std8ToUTF8 <source_file_name>"); Out.Ln; Out.Ln
END ShowHelp;

PROCEDURE ChkArg;
BEGIN
   IF Args.argc < 1 THEN ShowHelp END
END ChkArg;

PROCEDURE Convert;
VAR f : Files.File;
    r : Files.Rider;
    name : ARRAY 32 OF CHAR;
    length, pos: LONGINT;
    ch : CHAR;
    s : string;
BEGIN
   Args.Get(1, name);
   (*Out.String(name); Out.Ln;*)
   f := Files.Old(name);
   IF f # NIL THEN
      Files.Set(r, f, 0);
      length := Files.Length(f);
      REPEAT
         Files.Read(r, ch);
	 IF ORD(ch) = 195 THEN
            Files.Read(r, ch);
            IF (ORD(ch) >= 128) & (ORD(ch) <= 164) THEN
               s := G2U(ch);
               Out.String(s^)
            ELSE
               Out.Char(ch)
            END
	 ELSE
            IF ch # 0CX THEN Out.Char(ch) END
	 END;
         pos := Files.Pos(r);
      UNTIL pos >= length - 1;
   ELSE
      Out.String("file not found"); Out.Ln;
   END
END Convert;

PROCEDURE Map;
BEGIN
map[128] := "ა";
map[129] := "ბ";
map[130] := "გ";
map[131] := "დ";
map[132] := "ე";
map[133] := "ვ";
map[134] := "ზ";
map[136] := "თ";
map[137] := "ი";
map[138] := "კ";
map[139] := "ლ";
map[140] := "მ";
map[141] := "ნ";
map[143] := "ო";
map[144] := "პ";
map[145] := "ჟ";
map[146] := "რ";
map[147] := "ს";
map[148] := "ტ";
map[150] := "უ";
map[151] := "ფ";
map[152] := "ქ";
map[153] := "ღ";
map[154] := "ყ";
map[155] := "შ";
map[156] := "ჩ";
map[157] := "ც";
map[158] := "ძ";
map[159] := "წ";
map[160] := "ჭ";
map[161] := "ხ";
map[163] := "ჯ";
map[164] := "ჰ";
END Map;

BEGIN
ChkArg;

Map;
Convert;

END Std8ToUTF8.
