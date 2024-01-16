program day6p2(output);
{$I BIGILIB.PAS}
type
  str16 = string[16];
  str64 = string[64];
var
  numfile: text;
  line: str64;
  sq, tm, tm2, dt, res, first, last: BigInt;

procedure getvals(ln: str64; var tord: BigInt);
var j: integer;
begin
  tord := '';
  j := pos(':',line) + 2;   { First digit is at least 2 places after : }
  while j <= length(ln) do  { Last digit is at end of line }
  begin
    while not (ln[j] in ['0'..'9']) do
      j := j+1;
    while ln[j] in ['0'..'9'] do
    begin
      tord := tord+ln[j];
      j := j+1
    end
  end
end;

function getdist(dps,dur: BigInt): BigInt;
begin
  getdist := multiply(dps,dur)
end;

begin
  writeln('Advent of Code 2023 Day 6, part 2');
  assign(numfile,'day6in.txt');
  reset(numfile);
  while not eof(numfile) do
  begin
    readln(numfile,line);
    getvals(line,tm); { Time }
    readln(numfile,line);
    getvals(line,dt); { Distance }
  end;
  close(numfile);

  { Distance to beat is dt. Solve for x = (tm +/- sqrt(tm*tm - 4*dt))/2 }
  { and the answer we want is the difference between the two solutions  }
  dt := multiply(dt,'4');
  tm2 := multiply(tm,tm);
  dt := sub(tm2,dt);
  writeln('');
  writeln('(Calculating square root of ',dt, ' - this takes some time!)');
  sq := isqrt(dt);
  writeln('(Square root found is ',sq,')');
  first := divide(add(tm,sq),'2');
  last := divide(sub(tm,sq),'2');

  writeln ('');
  writeln ('Possible ways to win in a record time is ',sub(first,last))
end.
