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
  line: ARRAY [0..80] OF CHAR;
  fwd: ARRAY [1..ALLD] OF Str5;
  bck: ARRAY [1..ALLD] OF Str5;
  fdx, idx, ipos, jdx, ans, anst, proc, total: CARDINAL;
  reply: INTEGER;

PROCEDURE reverse(VAR str: ARRAY OF CHAR);
VAR ch: ARRAY [0..80] OF CHAR;
    i,len: CARDINAL;
BEGIN
  len := Length(str)-1;
  FOR i := 0 TO len DO
    ch[i] := str[len-i];
  END;
  FOR i := 0 TO len DO
    str[i] := ch[i];
  END;
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
    bck[i] := fwd[i];
    reverse(bck[i]);
  END;
END initfb;

BEGIN
  WriteString('Advent of Code 2023 Day 1, part 2');
  WriteLn; WriteLn;
  Lookup(calFile,'day1in.txt',reply);
  IF reply < 0 THEN
    WriteString('day1in.txt not found!');
    HALT;
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
      ReadChar(calStream,ch);
    END;
    (* Null terminate line *)
    line[idx] := CHAR(0);
    INC(proc);

    ipos := idx;
    jdx := 1;
    WHILE (jdx <= ALLD) & (ipos # 0) DO
      fdx := Pos(fwd[jdx],line,0);
      IF fdx < ipos THEN
        ipos := fdx;
        anst := 0;
        IF jdx > 9 THEN
          anst := (jdx-9)*10
        ELSE
          anst := jdx*10
        END;
      END;
      INC(jdx);
    END;

    ans := anst;
    reverse(line);

    ipos := idx;
    jdx := 1
    WHILE (jdx <= ALLD) & (ipos # 0) DO
      fdx := Pos(bck[jdx],line,0);
      IF fdx < ipos THEN
        ipos := fdx;
        anst := 0;
        IF jdx > 9 THEN
          anst := jdx-9;
        ELSE
          anst := jdx
        END;
      END;
      INC(jdx);
    END;

    ans := ans+anst;
    total := total + ans;
    IF (proc MOD 50) = 0 THEN
      WriteString('Processed ');WriteCard(proc,4);
      WriteString(' Running total is ');WriteCard(total,5);WriteLn;
    END;
    ReadChar(calStream,ch);
  END;

  Disconnect(calStream,TRUE);
  WriteString (' '); WriteLn;
  WriteString ('Sum of calibration values is ');
  WriteCard(total,5); WriteLn;
END day1p2.
