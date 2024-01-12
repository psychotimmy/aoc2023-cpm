program day1p2(output);
{$I BIGILIB.PAS}
type
  str5 = string[5];
  str80 = string[80];
const
  DIGITS = 18;
var
  calfile: text;
  fwd: array[1..DIGITS] of str5;
  bck: array[1..DIGITS] of str5;
  line: str80;
  i, idx, ansl, ansr, idxpos: integer;
  ansb, total: BigInt;

function reverse(str:str80): str80;
{ Reverse the input string str }
var
  strr: str80;
  i,len: integer;
begin
  strr := '';
  len := length(str);
  for i := 1 to len do
    strr := strr+str[len-i+1];
  reverse := strr
end;

procedure initfb;
{ Initialise the forward and backwards versions of digits 1..9 }
{ 1..9 are the same forward as backwards of course }
var
  i: integer;
begin
  for i := 1 to 9 do
  begin
    str(i,fwd[i]);
    bck[i] := fwd[i]
  end;
  fwd[10] := 'one';
  fwd[11] := 'two';
  fwd[12] := 'three';
  fwd[13] := 'four';
  fwd[14] := 'five';
  fwd[15] := 'six';
  fwd[16] := 'seven';
  fwd[17] := 'eight';
  fwd[18] := 'nine';
  for i := 10 to DIGITS do
    bck[i] := reverse(fwd[i])
end;

begin
  writeln('Advent of Code 2023 Day 1, part 2');
  writeln(' ');
  assign(calfile,'day1in.txt');
  reset(calfile);
  total := '0';
  initfb;
  while not eof(calfile) do
  begin
    readln(calfile,line);
    { Get the left (tens) digit }
    ansl := 0;
    idxpos := length(line);
    for i:= 1 to DIGITS do
    begin
      idx := pos(fwd[i],line);
      { idx is 0 if fwd[i] not in line }
      if (idx <> 0) and (idx <= idxpos) then
      begin
        idxpos := idx;
        ansl := i
      end
    end;
    if ansl > 9 then { It's a written digit }
      ansl := ansl - 9;
    ansl := ansl*10; { This is the tens value }

    { Get the right (units) digit }
    line := reverse(line);
    ansr := 0;
    idxpos := length(line);
    for i:= 1 to DIGITS do
    begin
      idx := pos(bck[i],line);
      { idx is 0 if bck[i] not in line }
      if (idx <> 0) and (idx <= idxpos) then
      begin
        idxpos := idx;
        ansr := i
      end
    end;
    if ansr > 9 then { It's a written digit }
      ansr := ansr - 9;

    { Add the new calibration value to the total }
    str(ansl,ansb);
    total := add(total,ansb);
    str(ansr,ansb);
    total := add(total,ansb)
  end;
  close(calfile);
  writeln('');
  writeln('Sum of calibration values is ',total)
end.
