program day2p2(output);
{$I BIGILIB.PAS}
type
  str255 = string[255];
var
  gamefile: text;
  line: str255;
  rmin, gmin, bmin: integer;
  rminb, gminb, bminb, total: BigInt;

{ Get colour value }
function getcol(ln: str255; idx: integer) : integer;
var tot, t, j, ierr : integer;
begin
  tot := 0;
  t := 1;
  while (ln[idx] <> ' ') do
  begin
    val(ln[idx],j,ierr);
    if ierr = 0 then
      tot := tot + j*t;
    t := t*10;
    idx := idx-1
  end;
  getcol := tot  { function return }
end;

{ Return the minimum possible values of r,g,b for each game }
procedure gamevals(line: str255; var rval: integer;
                   var gval: integer; var bval : integer);
var i, tot, curpos: integer;
    tempstr : str255;
begin
  { Minimum possible value is the largest value drawn for each colour }
  tempstr := line;
  { Parse the line into r,g,b values }
  { Check red }
  rval := 0;
  curpos := pos('red', tempstr);
  while curpos > 0 do
  begin
    i := curpos - 2; { index of the last digit of the value is 2 back from start of colour }
    tot := getcol(tempstr, i);
    if tot > rval then
      rval := tot;
    for i := i to curpos+2 do
      tempstr[i] := ' '; { Blank out this value and try red again }
    curpos := pos('red', tempstr)
  end;
  { Check blue }
  bval := 0;
  curpos := pos('blue', tempstr);
  while curpos > 0 do
  begin
    i := curpos - 2; { index of the last digit of the value is 2 back from start of colour }
    tot := getcol(tempstr, i);
    if tot > bval then
      bval := tot;
    for i := i to curpos+3 do
      tempstr[i] := ' '; { Blank out this value and try blue again }
    curpos := pos('blue', tempstr)
  end;
  { Check green }
  gval := 0;
  curpos := pos('green', tempstr);
  while curpos > 0 do
  begin
    i := curpos - 2; { index of the last digit of the value is 2 back from start of colour }
    tot := getcol(tempstr, i);
    if tot > gval then
      gval := tot;
    for i := i to curpos+4 do
      tempstr[i] := ' '; { Blank out this value and try green again }
    curpos := pos('green', tempstr)
  end
end;

begin
  writeln('Advent of Code 2023 Day 2, part 2');
  writeln(' ');
  assign(gamefile,'day2in.txt');
  reset(gamefile);
  total := '0';
  while not eof(gamefile) do
  begin
    readln(gamefile,line);           { Read the next line in file }
    gamevals(line,rmin,gmin,bmin);   { Get the minimum r,g,b values for game }
    str(rmin,rminb);
    str(gmin,gminb);
    str(bmin,bminb);
    total := add(total,multiply(rminb,multiply(gminb,bminb)))
    {; writeln('Running total is ',total) }
  end;
  close(gamefile);
  writeln ('Power of all games is ',total)
end.
