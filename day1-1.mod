MODULE day1p1;
FROM Terminal IMPORT WriteString, WriteLn;
FROM SmallIO IMPORT WriteCard;
FROM Files IMPORT FileName, FILE, Lookup;
FROM Streams IMPORT Connect, Disconnect, STREAM, input,
                    ReadChar, EOS;
TYPE
  CharSet = SET OF CHAR;
CONST
  EOLN = 0dx;
  ORD0 = 48;
  Digits = CharSet {'1'..'9'};
VAR
  calFile: FILE;
  calStream: STREAM;
  ch: CHAR;
  line: ARRAY [0..100] OF CHAR;
  idx, jdx, ans, total: CARDINAL;
  reply: INTEGER;
BEGIN
  WriteString('Advent of Code 2023 Day 1, part 1');
  WriteLn;
  Lookup(calFile,'day1in.txt',reply);
  IF reply < 0 THEN
    WriteString('day1in.txt not found!');
    HALT;
  END;
  Connect(calStream,calFile,input);
  total := 0;
  ReadChar(calStream,ch);
  WHILE NOT EOS(calStream) DO
    idx := 0;
    WHILE (ch <> EOLN) DO
      line[idx] := ch;
      INC(idx);
      ReadChar(calStream,ch);
    END;

    jdx := 0;
    WHILE NOT (line[jdx] IN Digits) DO
       INC(jdx);
    END;

    ans := (ORD(line[jdx])-ORD0)*10;

    jdx := idx-1;
    WHILE NOT (line[jdx] IN Digits) DO
       DEC(jdx);
    END;

    ans := ans+(ORD(line[jdx])-ORD0);
    total := total + ans;

    ReadChar(calStream,ch);
  END;

  Disconnect(calStream,TRUE);
  WriteString (' '); WriteLn;
  WriteString ('Sum of calibration values is ');
  WriteCard(total,5); WriteLn;
END day1p1.
