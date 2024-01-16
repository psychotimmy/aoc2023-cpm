program day2p1(output);
{$I BIGILIB.PAS}
type
  str255 = string[255];
const
  RMAX = 12;
  GMAX = 13;
  BMAX = 14;
var
  gamefile : text;
  line : str255;
  gid, i: integer;
  total, gidb: BigInt;

{ Get the game id from the start of the line }
function getgid(ln: str255) : integer;
var i, j, ierr, total: integer;
begin
  { Game id's start at position 6 in line }
  i := 6;
  total := 0;
  while (ln[i] <> ' ') do
  begin
    val(ln[i],j,ierr);
    if ierr = 0 then
      total := total*10 + j;
    i := i+1
  end;
  getgid := total { function return }
end;

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

{ Return true if the game is valid }
function validgame(line: str255) : boolean;
var i, j, t, tot, curpos: integer;
    gameval : boolean;
    tempstr : str255;
begin
  { If any one of the values exceeds the maximum value then game is invalid }
  gameval := true;
  tempstr := line;
  { Parse the line into r,g,b values }
  { Check red }
  curpos := pos('red', tempstr);
  while (curpos > 0) and gameval do
  begin
    i := curpos - 2; { index of the last digit of the value is 2 back from start of colour }
    tot := getcol(tempstr, i);
    if tot > RMAX then
      gameval := false
    else
    begin
    for i := i to curpos+2 do
      tempstr[i] := ' '; { Blank out this value and try red again if game still valid }
      curpos := pos('red', tempstr)
    end
  end;
  { Check blue }
  curpos := pos('blue', tempstr);
  while (curpos > 0) and gameval do
  begin
    i := curpos - 2; { index of the last digit of the value is 2 back from start of colour }
    tot := getcol(tempstr, i);
    if tot > BMAX then
      gameval := false
    else
    begin
    for i := i to curpos+3 do
      tempstr[i] := ' '; { Blank out this value and try blue again if game still valid }
      curpos := pos('blue', tempstr)
    end
  end;
  { Check green }
  curpos := pos('green', tempstr);
  while (curpos > 0) and gameval do
  begin
    i := curpos - 2; { index of the last digit of the value is 2 back from start of colour }
    tot := getcol(tempstr, i);
    if tot > GMAX then
      gameval := false
    else
    begin
    for i := i to curpos+4 do
      tempstr[i] := ' '; { Blank out this value and try green again if game still valid }
      curpos := pos('green', tempstr)
    end
  end;
  validgame := gameval { function return }
end;

begin
  writeln('Advent of Code 2023 Day 2, part 1');
  writeln(' ');
  assign(gamefile,'day2in.txt');
  reset(gamefile);
  total := '0';
  while not eof(gamefile) do
  begin
    readln(gamefile,line);    { Read the next line in file }
    gid := getgid(line);      { Get the game identifier }
    if validgame(line) then   { If valid, add it to the total }
    begin
      str(gid,gidb);
      total := add(total,gidb)
    end
  end;
  close(gamefile);
  writeln ('Sum of rgb cubes from valid games is ',total)
end.
