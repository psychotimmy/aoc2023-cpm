program day11p1(output);
{$I BIGILIB.PAS}
const
  MAXY = 140;
  MAXX = 140;
type
  str140 = string[140];
  expset = set of 1..MAXX;
  coords = record
             xx: integer;
             yy: integer
           end;
var
  galxfile: text;
  line: str140;
  gcoords: array [1..450] of coords;
  galx, x, galy, y, gtotal: integer;
  exprows, expcols : expset;
  xa,ya,xb,yb: integer;
  gdistb, total: BigInt;

procedure populategalx(ln: str140; row:integer);
var i: integer;
begin
  galx := length(ln);
  for i := 1 to galx do
    if ln[i] = '#' then
    begin
      gtotal := gtotal + 1;          { New galaxy found }
      gcoords[gtotal].xx := i;
      expcols := expcols-[i];        { No longer an expansion column }
      gcoords[gtotal].yy := row;
      exprows := exprows-[row]       { No longer an expansion row }
    end
end;

procedure expandcoords(var c:integer; var r:integer);
var toadd, i: integer;
begin
  toadd := 0;
  for i:= 1 to c-1 do     { Don't need to check row/col }
    if i in expcols then  { the galaxy coord is in }
      toadd := toadd+1;
  c := c + toadd;

  toadd := 0;
  for i:= 1 to r-1 do
    if i in exprows then
       toadd := toadd+1;
  r := r + toadd

end;

function manhattan(x1,y1,x2,y2: integer):integer;
begin
  manhattan := abs(x1-x2)+abs(y1-y2)
end;

begin
  writeln('Advent of Code 2023 Day 11, part 1');
  writeln ('');

  { Empty universe to start with - every row and column can expand }
  expcols := [];
  for x := 1 to MAXX do
    expcols := expcols+[x];
  exprows := [];
  for y := 1 to MAXY do
    exprows := exprows+[y];

  { Populate the universe with galaxies }
  assign(galxfile,'day11in.txt');
  reset(galxfile);
  gtotal := 0;  { Number of galaxies in the universe }
  galy := 0;
  while not eof(galxfile) do
  begin
    galy := galy+1;
    readln(galxfile,line);
    populategalx(line,galy)
  end;
  close(galxfile);

  writeln('Unexpanded universe is ', galx,' by ',galy);
  writeln('Number of galaxies is ',gtotal);
  write('Expansion columns are ');
  for x := 1 to MAXX do
    if x in expcols then write(x,' ');
  writeln('');
  write('Expansion rows are ');
  for y := 1 to MAXY do
    if y in exprows then write(y,' ');
  writeln('');

  { Expand each galaxy }
  writeln('Expanding the universe');
  for x := 1 to gtotal do
  begin
    xa := gcoords[x].xx;
    ya := gcoords[x].yy;
    expandcoords(xa,ya);
    gcoords[x].xx := xa;
    gcoords[x].yy := ya
  end;
  writeln('Expansion complete');

  { For each pair of galaxies, work out the minimum distance between }
  { them, allowing for the universe expansion. Sum the totals.       }
  total := '0';
  for x := 1 to gtotal-1 do
  begin
    xa := gcoords[x].xx;
    ya := gcoords[x].yy;
    for y := x+1 to gtotal do
    begin
      xb := gcoords[y].xx;
      yb := gcoords[y].yy;

      { Find the manhattan distance between the pair }
      str(manhattan(xa,ya,xb,yb),gdistb);
      total := add(total,gdistb)
    end;
    writeln('Running total of minimum distances after ',x,' galaxies is ',total)
  end;
  writeln ('');
  writeln ('Sum of minimum distances between all galaxy pairs is ',total)
end.
