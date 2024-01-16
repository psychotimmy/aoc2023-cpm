program day13p2(output);
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
  smudgerow,smudgecol,oldval,newval,col,idcol,idrow,field: integer;
  oldtotal,total,oldvalb,newvalb: BigInt;

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

function mirror(rowmax,colmax,before:integer):integer;
var startp,endp,c,r: integer;
begin

  { Only one line of reflection is present - row or column     }
  { If we find a row reflection, don't bother with the columns }
  { ... unless (!) we're fixing a smudge and the oldval is the }
  { same as the newvalue found for the row - then we must      }
  { check the columns to see if it's flipped its axis. D'oh.   }

  { Column reflections }
  startp := 1;
  endp := colmax;

  { Strings are easier to compare }
  for c := 1 to colmax do
  begin
    rockcol[c] := '';
    for r := 1 to rowmax do
      rockcol[c] := rockcol[c]+rockgrid[r,c]
  end;

  for c := 1 to colmax do
  begin
    startp := c;
    endp := c+1;
    if colreflection(startp,endp) then
      if c <> before then
      begin
        mirror := c;
        exit { Function return if it's not the same as before }
      end
  end;

  { Row reflections }
  startp := 1;
  endp := rowmax;

  { Strings are easier to compare }
  for r := 1 to rowmax do
  begin
    rockrow[r] := '';
    for c := 1 to colmax do
      rockrow[r] := rockrow[r]+rockgrid[r,c]
  end;

  for r := 1 to rowmax do
  begin
    startp := r;
    endp := r+1;
    if rowreflection(startp,endp) then
      if (r*100) <> before then
      begin
        mirror := r*100;
        exit  { Function return if it's not the same as before }
      end
  end;

  mirror := 0     { Indicates a mirror line has not been found }

end;

begin
  writeln('Advent of Code 2023 Day 13, part 2');
  writeln ('');

  assign(rockfile,'day13in.txt');
  reset(rockfile);
  total := '0';
  oldtotal := '0';
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

    { Get the original mirror line's value }
    oldval := mirror(idrow,idcol,0);

    { Smudge each mirror in turn }
    newval := 0;
    smudgerow := 1;
    smudgecol := 1;
    while ((newval = oldval) or (newval = 0)) and (smudgerow < idrow+1) do
    begin
      { Flip the next ash/rock in the field }
      if rockgrid[smudgerow,smudgecol] = '#' then
        rockgrid[smudgerow,smudgecol] := '.'
      else
        rockgrid[smudgerow,smudgecol] := '#';

      { Find the new mirror line}
      newval := mirror(idrow,idcol,oldval);

      { Flip the current ash/rock back in case newval isn't different or zero }
      if rockgrid[smudgerow,smudgecol] = '#' then
        rockgrid[smudgerow,smudgecol] := '.'
      else
        rockgrid[smudgerow,smudgecol] := '#';

      { Increment smudgerow and smudgecol as required }
      smudgecol := smudgecol + 1;
      if smudgecol > idcol then
      begin
        smudgerow := smudgerow+1;
        smudgecol := 1
      end
    end;

    str(oldval,oldvalb);
    str(newval,newvalb);
    oldtotal := add(oldtotal,oldvalb);
    total := add(total,newvalb);

    writeln('Part 2 running total after ',field,' fields processed is ',total);
    writeln('(Part 1 running total after ',field,' fields processed is ',oldtotal,')');
    writeln ('')
  end;
  close(rockfile);
  writeln ('Sum of reflection columns plus sum of reflecion rows x 100 is ',total)
end.
