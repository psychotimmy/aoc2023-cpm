program day21p1(output);
const
  MAXROW = 131;  { Puzzle input is 131x131 }
  MAXCOL = 131;
type
  str132 = string[132];
  direction = (north,east,south,west);
var
  gridfile: text;
  gridcur: array[1..MAXROW,1..MAXCOL] of char;
  gridnxt: array[1..MAXROW,1..MAXCOL] of char;
  line: str132;
  x,y,col,idrow,idcol,total,steps: integer;

function takeSteps(ohs:integer): integer;
var rcur,ccur,rnxt,cnxt : integer;
    step: direction;
begin
  for rcur := 1 to idrow do
  begin
    for ccur := 1 to idcol do
    begin
      case gridcur[rcur,ccur] of
        '#' : begin
                gridnxt[rcur,ccur] := '#'
              end;
        'O' : begin
                gridnxt[rcur,ccur] := '.';
                for step := north to west do
                begin
                  case step of
                    north : begin
                              rnxt := rcur-1;
                              cnxt := ccur
                            end;
                    east  : begin
                              rnxt := rcur;
                              cnxt := ccur+1
                            end;
                    south : begin
                              rnxt := rcur+1;
                              cnxt := ccur
                            end;
                    west  : begin
                              rnxt := rcur;
                              cnxt := ccur-1
                            end
                  end;
                  if (rnxt >= 1) and
                     (rnxt <= idrow) and
                     (cnxt >= 1) and
                     (cnxt <= idcol) then
                    if gridcur[rnxt,cnxt] <> '#' then
                       gridnxt[rnxt,cnxt] := 'O'
                end
              end
      end
    end
  end;

  ohs := 0;
  for rcur := 1 to idrow do
    for ccur := 1 to idcol do
    begin
      gridcur[rcur,ccur] := gridnxt[rcur,ccur];
      if gridcur[rcur,ccur] = 'O' then
        ohs := ohs+1;
      gridnxt[rcur,ccur] := ' '
    end;

  takeSteps := ohs   { Function return }

end;

begin
  writeln('Advent of Code 2023 Day 21, part 1');
  writeln ('');

  assign(gridfile,'day21in.txt');
  reset(gridfile);
  readln(gridfile,line);
  while not eof(gridfile) do
  begin
    idrow := 1;
    idcol := length(line);
    while length(line) > 0 do
    begin
      for col := 1 to idcol do
      begin
        gridcur[idrow,col] := line[col];
        if gridcur[idrow,col] = 'S' then
          gridcur[idrow,col] := 'O';
      end;
      readln(gridfile,line);
      idrow := idrow+1
    end;
    idrow := idrow - 1
  end;
  close(gridfile);

  { Initialise and null gridnxt }
  for y := 1 to idrow do
    for x := 1 to idcol do
      gridnxt[x,y] := char(0);

  { Number of plots reached at start position is 1 }
  total := 1;
  for steps := 1 to 64 do
  begin
    total := takeSteps(total);
    writeln('Plots reached after ',steps,' steps is ',total)
  end;
  writeln ('Garden plots reached in exactly 64 steps is ',total)
end.
