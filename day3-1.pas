program day3p1(output);
{$I BIGILIB.PAS}
type
  str16 = string[16];
  str150 = string[150];
var
  partfile: text;
  line: str150;
  colmax,rowmax,i,j: integer;
  grid: array[1..3,1..150] of char;
  total,getpartsb: BigInt;

procedure gridsize(var r: integer; var c: integer; fname: str16);
{ Return #rows and #columns in the grid in the file }
var
  pfile : text;
  ln : str150;
begin
  assign(pfile,fname);
  reset(pfile);
  while not eof(pfile) do
  begin
    readln(pfile,ln);
    r := r + 1
  end;
  c := length(ln); { Assumes all rows are the same length }
  close(pfile)
end;

function boxcheck(start, finish: integer): boolean;
{ Check the box around the number for symbols }
var x, y: integer;
begin
   boxcheck := false;
   for x := 1 to 3 do
     for y := start to finish do
       if (grid[x,y] <> '.') and (not (grid[x,y] in ['0'..'9'])) then
         boxcheck := true
end;

function getparts: integer;
{ Get the value of the parts on the current row }
var i, n, sp, pn, pnt, ierr : integer;
begin
  pnt := 0;
  i := 2;
  while i < colmax+2 do
  begin
    while (not (grid[2,i] in ['0'..'9'])) and (i < colmax+2) do
      i := i + 1;
    sp := i-1;  { Starting point for box check is one back from the number }
    pn := 0;
    while grid[2,i] in ['0'..'9'] do
    begin
      val(grid[2,i],n,ierr);
      if ierr = 0 then
        pn := pn*10 + n;
      i := i+1
    end;
    { If the box around the number has a symbol in it, then part number is valid }
    if boxcheck(sp,i) then
      pnt := pnt + pn
  end;
  getparts := pnt { Function return }
end;

begin
  writeln('Advent of Code 2023 Day 3, part 1');
  total := '0';

  { Find the input grid size }
  rowmax := 0;
  colmax := 0;
  gridsize(rowmax,colmax,'day3in.txt');
  writeln(rowmax,' rows to process');

  { We will use a grid with a blank border for simplicity }
  { Set up the first three lines of the grid }
  { Top and bottom rows are always blank }
  { Left and right hand columns are always blank }

  assign(partfile,'day3in.txt');
  reset(partfile);
  { We work on the grid a line at a time }
  { The line being examined is always grid[2,1..colmax+2] }
  { The lines above and below are stored }
  for i := 1 to rowmax do {rowmax}
  begin
    if i = 1 then
    begin
      for j := 1 to colmax+2 do
        grid[1,j] := '.';
      readln(partfile,line);
      grid[2,1] := '.';
      for j := 1 to length(line) do
        grid[2,j+1] := line[j];
      grid[2,colmax+2] := '.';
      readln(partfile,line);
      grid[3,1] := '.';
      for j := 1 to length(line) do
        grid[3,j+1] := line[j];
      grid[3,colmax+2] := '.'
    end
    else
    begin
      for j := 1 to colmax+2 do
      begin
        grid[1,j] := grid[2,j];
        grid[2,j] := grid[3,j]
      end;
      if i <> rowmax then
      begin
        readln(partfile,line);
        grid[3,1] := '.';
        for j := 1 to length(line) do
          grid[3,j+1] := line[j];
        grid[3,colmax+2] := '.'
      end
      else
      for j := 1 to colmax+2 do
        grid[3,j] := '.'
    end;
    { Get the parts value for each line and add to total }
    str(getparts,getpartsb);
    total := add(total,getpartsb);
    writeln('Running total after ',i,' rows processed is ',total)
  end;
  close(partfile);
  writeln ('');
  writeln ('Sum of valid part numbers is ',total)
end.
