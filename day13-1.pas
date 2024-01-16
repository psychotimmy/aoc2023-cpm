program day13p1(output);
{$I BIGILIB.PAS}
const
  MAXROW = 17;  { Largest puzzle input is 17x17 }
  MAXCOL = 17;
type
  str17 = string[17];
  str20 = string[20];
var
  rockfile: text;
  rockgrid: array[1..MAXROW,1..MAXCOL] of char;
  rockrow: array[1..MAXROW] of str17;
  rockcol: array[1..MAXCOL] of str17;
  line: str20;
  row,col,idcol,idrow,field,startp,endp,rows,cols,total: integer;
  totalb, grandtotal: BigInt;

procedure nullgrid;
var x,y: integer;
begin
  for y := 1 to MAXCOL do
  begin
    rockcol[y] := '';
    for x := 1 to MAXROW do
    begin
      rockrow[x] := '';
      rockgrid[x,y] := char(0)
    end
  end
end;

function rowreflection (var sp:integer; var fp:integer):boolean;
begin
  { Base cases }
  if rockrow[sp] <> rockrow[fp] then
  begin
    rowreflection := false
  end
  else
  begin
    if (sp = 1) or (fp = idrow) then
    begin
      rowreflection := true
    end
    else
    begin
      { Otherwise work to do }
      sp := sp-1;
      fp := fp+1;
      rowreflection := rowreflection(sp,fp)
    end
  end
end;

function colreflection (var sp:integer; var fp:integer):boolean;
begin
  { Base cases }
  if rockcol[sp] <> rockcol[fp] then
  begin
    colreflection := false
  end
  else
  begin
    if (sp = 1) or (fp = idcol) then
    begin
      colreflection := true
    end
    else
    begin
      { Otherwise work to do }
      sp := sp-1;
      fp := fp+1;
      colreflection := colreflection(sp,fp)
    end
  end
end;

begin
  writeln('Advent of Code 2023 Day 13, part 1');
  writeln ('');

  assign(rockfile,'day13in.txt');
  reset(rockfile);
  grandtotal := '0';
  field := 0;
  readln(rockfile,line); { No blank line at start of file }
  while not eof(rockfile) do
  begin
    nullgrid;
    field := field + 1;
    idrow := 1;
    idcol := length(line);
    while length(line) > 0 do
    begin
      for col := 1 to idcol do
        rockgrid[idrow,col] := line[col];
      readln(rockfile,line);
      idrow := idrow+1
    end;
    readln(rockfile,line); { while has skipped blank line between fields }
    idrow := idrow -1;

    { Deal with row reflections first }
    startp := 1;
    endp := idrow;

    { Strings are easier to compare }
    for row := startp to endp do
      for col := 1 to idcol do
        rockrow[row] := rockrow[row]+rockgrid[row,col];

    for row := 1 to idrow do
    begin
      startp := row;
      endp := row+1;
      if rowreflection(startp,endp) then
      begin
        writeln('Reflection between rows ', row,' and ',row+1);
        rows := row
      end
    end;

    { Now column reflections }
    startp :=1;
    endp := idcol;

    { Strings are easier to compare }
    for col := startp to endp do
      for row := 1 to idrow do
        rockcol[col] := rockcol[col]+rockgrid[row,col];

    for col := 1 to idcol do
    begin
      startp := col;
      endp := col+1;
      if colreflection(startp,endp) then
      begin
        writeln('Reflection between cols ', col,' and ',col+1);
        cols := col
      end
    end;

    { Increment running total }
    total := rows*100+cols;
    str(total,totalb);
    grandtotal := add(grandtotal,totalb);
    { Reset rows and cols counters!! }
    rows := 0;
    cols := 0;
    writeln('Running total after ',field,' fields processed is ',grandtotal)
  end;
  close(rockfile);

  writeln ('');
  writeln ('Sum of reflection columns plus sum of reflecion rows x 100 is ',grandtotal)
end.
