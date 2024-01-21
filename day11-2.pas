program day11p2(output);
{$I BIGILIB.PAS}
const
  MAXY = 140;
  MAXX = 140;
type
  str140 = string[140];
  expset = set of 1..MAXX;
  coords = record
             xx: BigInt;
             yy: BigInt
           end;
var
  galxfile: text;
  line: str140;
  gcoords: array [1..450] of coords;
  galx, x, galy, y, gtotal, xai, yai, ierr: integer;
  exprows, expcols : expset;
  xa,ya,xb,yb: BigInt;
  gdistb, total: BigInt;

procedure populategalx(ln: str140; row:integer);
var i: integer;
    temp: BigInt;
begin
  galx := length(ln);
  for i := 1 to galx do
    if ln[i] = '#' then
    begin
      gtotal := gtotal + 1;          { New galaxy found }
      str(i,temp);
      gcoords[gtotal].xx := temp;
      expcols := expcols-[i];        { No longer an expansion column }
      str(row,temp);
      gcoords[gtotal].yy := temp;
      exprows := exprows-[row]       { No longer an expansion row }
    end
end;

procedure expandcoords(cin,rin: integer; var c: BigInt; var r:BigInt);
var i: integer;
    toadd: BigInt;
begin
  toadd := '0';
  str(cin,c);
  for i:= 1 to cin-1 do     { Don't need to check row/col }
    if i in expcols then  { the galaxy coord is in }
      toadd := add(toadd,'999999');
  c := add(c,toadd);

  toadd := '0';
  str(rin,r);
  for i:= 1 to rin-1 do
    if i in exprows then
       toadd := add(toadd,'999999');
  r := add(r,toadd)

end;

function manhattan(x1,y1,x2,y2: BigInt):BigInt;
var temp1, temp2:BigInt;
begin
  if gt(x1,x2) then
    temp1 := sub(x1,x2)
  else
    temp1 := sub(x2,x1);
  if gt(y1,y2) then
    temp2 := sub(y1,y2)
  else
    temp2 := sub(y2,y1);
  manhattan := add(temp1,temp2)
end;

begin
  writeln('Advent of Code 2023 Day 11, part 2');
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
    val(xa,xai,ierr);
    val(ya,yai,ierr);
    expandcoords(xai,yai,xa,ya);
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
      gdistb := manhattan(xa,ya,xb,yb);
      total := add(total,gdistb)
    end;
    writeln('Running total of minimum distances after ',x,' galaxies is ',total)
  end;
  writeln ('');
  writeln ('Sum of minimum distances between all galaxy pairs is ',total)
end.
