MODULE day1p2;
FROM Terminal IMPORT WriteString, WriteLn;
FROM SmallIO IMPORT WriteCard;
FROM Strings IMPORT Length, Pos;
FROM Files IMPORT FILE, Lookup;
FROM Streams IMPORT Connect, Disconnect, STREAM, input,
                    ReadChar, EOS;
TYPE
  Str5 = ARRAY [0..4] OF CHAR;
CONST
  EOLN = 0dx;
  ORD0 = 48;
  ALLD = 18;
VAR
  calFile: FILE;
  calStream: STREAM;
  ch: CHAR;
  line, lineb: ARRAY [0..70] OF CHAR;
  fwd: ARRAY [1..ALLD] OF Str5;
  bck: ARRAY [1..ALLD] OF Str5;
  llen, fdx, idx, spos, epos, jdx, anss, anse, proc, total: CARDINAL;
  reply: INTEGER;

PROCEDURE reverse(str1: ARRAY OF CHAR; VAR str2: ARRAY OF CHAR);
(* Assumes size str2 >= size str1 *)
VAR i,len: CARDINAL;
BEGIN
  len := Length(str1);
  FOR i := 0 TO len-1 DO
    str2[i] := str1[len-i-1]
  END;
  IF HIGH(str2) > len-1 THEN
    str2[len] := CHAR(0)
  END
END reverse;

PROCEDURE initfb();
VAR i: CARDINAL;
BEGIN
  FOR i := 1 TO 9 DO
   fwd[i,0] := CHR(ORD0+i);
   bck[i,0] := fwd[i,0]
  END;
  fwd[10] := 'one';
  fwd[11] := 'two';
  fwd[12] := 'three';
  fwd[13] := 'four';
  fwd[14] := 'five';
  fwd[15] := 'six';
  fwd[16] := 'seven';
  fwd[17] := 'eight';
  fwd[18] := 'nine';
  FOR i := 10 TO ALLD DO
    reverse(fwd[i],bck[i])
  END
END initfb;

BEGIN
  WriteString('Advent of Code 2023 Day 1, part 2');
  WriteLn; WriteLn;
  Lookup(calFile,'day1in.txt',reply);
  IF reply < 0 THEN
    WriteString('day1in.txt not found!');
    HALT
  END;
  Connect(calStream,calFile,input);
  total := 0;
  proc := 0;
  initfb();
  ReadChar(calStream,ch);
  WHILE NOT EOS(calStream) DO
    idx := 0;
    WHILE (ch <> EOLN) DO
      line[idx] := ch;
      INC(idx);
      ReadChar(calStream,ch)
    END;
    INC(proc);
    (* Null terminate line *)
    line[idx] := CHAR(0);
    (* And get the reverse *)
    reverse(line,lineb);
    (* Used to speed while loop up - Pos is horribly slow if the substring *)
    (* is longer than the string being checked - speeds up by around 30%!  *)
    llen := Length(line);

    spos := idx;
    epos := idx;
    jdx := 1;
    WHILE ((spos > 0) OR (epos > 0)) & (jdx <= ALLD) DO
      IF (spos > 0) & (Length(fwd[jdx]) < llen) THEN
        fdx := Pos(fwd[jdx],line,0);
        IF fdx # HIGH(line)+1 THEN
          IF fdx < spos THEN
            spos := fdx;
            anss := jdx
          END
        END
      END;
      IF (epos > 0) & (Length(bck[jdx]) < llen) THEN
        fdx := Pos(bck[jdx],lineb,0);
        IF fdx # HIGH(lineb)+1 THEN
          IF fdx < epos THEN
            epos := fdx;
            anse := jdx
          END
        END
      END;
      INC(jdx)
    END;

    IF anss > 9 THEN
      total := total + (anss-9)*10
    ELSE
      total := total + anss*10
    END;

    IF anse > 9 THEN
      total := total+anse-9
    ELSE
      total := total+anse
    END;

    IF (proc MOD 50) = 0 THEN
      WriteString('Processed ');WriteCard(proc,4);
      WriteString(' Running total is ');WriteCard(total,5);WriteLn
    END;
    ReadChar(calStream,ch)
  END;

  Disconnect(calStream,TRUE);
  WriteString (' '); WriteLn;
  WriteString ('Sum of calibration values is ');
  WriteCard(total,5); WriteLn
END day1p2.
