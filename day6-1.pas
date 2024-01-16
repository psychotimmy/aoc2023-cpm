program day6p1(output);
{$I BIGILIB.PAS}
const
  MAXRACES = 4;
type
  str4 = string[4];
  str64 = string[64];
var
  numfile : text;
  line : str64;
  speed, cpos, idx, races : integer;
  tm : array[1..MAXRACES] of integer;
  dt : array[1..MAXRACES] of integer;
  win, res, dtb, total : BigInt;

procedure getvals(ln: str64; var start: integer; var tmdt: integer);
var j,k,sp,fp,ierr : integer;
    st : str4;
begin
  j := start;
  while not (ln[j] in ['0'..'9']) do
    j := j+1;
  sp := j;
  while ln[j] in ['0'..'9'] do
    j := j+1;
  fp := j;
  st := copy(ln,sp,fp-sp);
  val(st,k,ierr);
  if ierr = 0 then
    tmdt :=  k;
  start := j+1
end;

function getdist(dps : integer; dur : integer): BigInt;
var dpsb, durb: BigInt;
begin
  str(dps,dpsb);
  str(dur,durb);
  getdist := multiply(dpsb,durb)
end;

begin
  writeln('Advent of Code 2023 Day 6, part 1');
  assign(numfile,'day6in.txt');
  reset(numfile);
  while not eof(numfile) do
  begin
    readln(numfile,line);
    cpos := pos(':',line) + 2; { First number is  at least 2 places after : }
    idx := 1;
    while cpos <= length(line) do
    begin
      getvals(line,cpos,tm[idx]); { Times }
      idx := idx+1
    end;

    readln(numfile,line);
    cpos := pos(':',line) + 2; { First number is  at least 2 places after : }
    idx := 1;
    while cpos <= length(line) do
    begin
      getvals(line,cpos,dt[idx]); { Distances }
      idx := idx+1
    end
  end;

  races := idx-1; { Total number of races is one less than idx }

  close(numfile);

  { For each race brute force the answer }

  total := '1';
  for idx := 1 to races do
  begin
    win := '0';
    for speed := 1 to tm[idx]-1 do
    begin
      res := getdist(speed,tm[idx]-speed);
      str(dt[idx],dtb);
      if gt(res,dtb) then
        win := add(win,'1');
    end;
    writeln('Race ',idx,' wins are ',win);
    total := multiply(total,win)
  end;

  writeln ('');
  writeln ('Product of possible record winning races is ',total)
end.
