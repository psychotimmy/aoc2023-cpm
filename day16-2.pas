program day16p2(output);
{$A-}            { Allow recursive code }
{$W1}            { With statements nested to 1 level only }
{$X-}            { Arrays optimised for space, not speed  }
const
  MAXROW = 110;  { Puzzle input is 110x110 }
  MAXCOL = 110;  { Sample input is 10x10 }
type
  direction = (none,east,south,west,north);
  coords = record
             xx: integer;
             yy: integer
           end;
var
  mirrgrid: array[1..MAXROW,1..MAXCOL] of char;
  beamgrid: array[1..MAXROW,1..MAXCOL] of direction;
  dir: direction;
  prev, this: coords;
  done: boolean;
  idrow, idcol, x, y, total, highscore: integer;

overlay procedure nullbeamgrid;
var x,y: integer;
begin
  for y := 1 to MAXCOL do
    for x := 1 to MAXROW do
      beamgrid[x,y] := none;
end;

overlay procedure nullgrids;
var x,y: integer;
begin
  for y := 1 to MAXCOL do
    for x := 1 to MAXROW do
    begin
      mirrgrid[x,y] := char(0);
      beamgrid[x,y] := none
    end
end;

overlay function energised: integer;
var r,c,energy: integer;
begin
  energy := 0;
  for r := 1 to idrow do
    for c := 1 to idcol do
      if (beamgrid[r,c] <> none) then
        energy := energy+1;

  energised := energy  { Function return }
end;

overlay procedure readinput;
var mirrfile: text;
    line: string[110];
    col: integer;
begin
  assign(mirrfile,'day16in.txt');
  reset(mirrfile);
  readln(mirrfile,line);
  while not eof(mirrfile) do
  begin
    idrow := 1;
    idcol := length(line);
    while length(line) > 0 do
    begin
      for col := 1 to idcol do
        mirrgrid[idrow,col] := line[col];
      readln(mirrfile,line);
      idrow := idrow+1
    end;
    idrow := idrow - 1
  end;
  close(mirrfile)
end;

function processgrid(var direct: direction;
                     var prevc: coords;
                     var thisc: coords): boolean;
var pg: boolean;
var saveprev, savethis: coords;
begin
  { Calculate current co-ordinates from direction and previous }
  case direct of
    east  : thisc.yy := prevc.yy+1;
    west  : thisc.yy := prevc.yy-1;
    south : thisc.xx := prevc.xx+1;
    north : thisc.xx := prevc.xx-1
  end;

  { Base case is that this coordinate is off grid }
  { so end processing of the beam quickly }
  if (thisc.xx > idcol) or (thisc.xx < 1) or
     (thisc.yy > idrow) or (thisc.yy < 1) then
  begin
    processgrid := true;
    exit
  end;

  { Mark this square in the result grid        }
  { Don't care how many times it's been marked }
  { But we do care if we've hit this square in }
  { the same direction before ... as we have a }
  { infinite loop otherwise! This is also a    }
  { base case exit if that's true.             }
  case direct of
    east : begin
             if beamgrid[thisc.xx,thisc.yy] = east then
             begin
               processgrid := true;
               exit
             end
             else
               beamgrid[thisc.xx,thisc.yy] := east
           end;
    west : begin
             if beamgrid[thisc.xx,thisc.yy] = west then
             begin
               processgrid := true;
               exit
             end
             else
               beamgrid[thisc.xx,thisc.yy] := west
           end;
    south: begin
             if beamgrid[thisc.xx,thisc.yy] = south then
             begin
               processgrid := true;
               exit
             end
             else
               beamgrid[thisc.xx,thisc.yy] := south
           end;
    north: begin
             if beamgrid[thisc.xx,thisc.yy] = north then
             begin
               processgrid := true;
               exit
             end
             else
               beamgrid[thisc.xx,thisc.yy] := north
           end
  end;

  { This position will always become the previous position }
  prevc.xx := thisc.xx;
  prevc.yy := thisc.yy;

  { Work out what to do with the beam }
  case mirrgrid[this.xx,this.yy] of
    '.' : begin
            processgrid := false;
            exit
          end;
    '/' : begin
            case direct of
              east : direct := north;
              west : direct := south;
              north: direct := east;
              south: direct := west
            end;
            processgrid := false;
            exit
          end;
    '\' : begin
            case direct of
              east : direct := south;
              west : direct := north;
              north: direct := west;
              south: direct := east
             end;
             processgrid := false;
             exit
           end;
     '-' : begin
             case direct of
               east,west  : begin
                              processgrid := false;
                              exit
                            end;
               south,north: begin
                              direct := east;
                              pg := false;
                              saveprev := prevc;
                              savethis := thisc;
                              while not pg do
                                pg := processgrid(direct,prevc,thisc);
                              direct := west;
                              pg := false;
                              prevc := saveprev;
                              thisc := savethis;
                              while not pg do
                                pg := processgrid(direct,prevc,thisc)
                            end
             end
           end;
     '|' : begin
             case direct of
               south,north : begin
                               processgrid := false;
                               exit
                             end;
               west,east   : begin
                               direct := north;
                               pg := false;
                               saveprev := prevc;
                               savethis := thisc;
                               while not pg do
                                 pg := processgrid(direct,prevc,thisc);
                               direct := south;
                               pg := false;
                               prevc := saveprev;
                               thisc := savethis;
                               while not pg do
                                 pg := processgrid(direct,prevc,thisc)
                             end
             end
           end
  end;
  processgrid := true
end;

begin
  writeln('Advent of Code 2023 Day 16, part 2');
  writeln('');

  highscore := 0;
  nullgrids;
  readinput;

  { East firings }
  writeln('East ...');
  for x := 1 to idrow do
  begin
    nullbeamgrid;
    { Set the beam off to the east side of the grid }
    { for each row in the grid }
    prev.yy := 0;
    prev.xx := x;
    this.yy := 1;
    this.xx := x;
    { Set the direction of travel for the beam }
    dir := east;

    { And recursively process the beam(s) }
    done := processgrid(dir,prev,this);
    while not done do
      done := processgrid(dir,prev,this);

    { Count the total number of energised grid squares }
    total := energised;
    { ... and save the highest score }
    if total > highscore then
    begin
      writeln ('New high score ',total,' from Eastern firing at row ',x);
      highscore := total
    end
    else
      writeln ('Score ',total,' from Eastern firing at row ',x)
  end;

  { North firings }
  writeln('');
  writeln('North ...');
  for x := 1 to idcol do
  begin
    nullbeamgrid;
    { Set the beam off to the north side of the grid }
    { for each row in the grid }
    prev.yy := x;
    prev.xx := idrow+1;
    this.yy := x;
    this.xx := 1;
    { Set the direction of travel for the beam }
    dir := north;

    { And recursively process the beam(s) }
    done := processgrid(dir,prev,this);
    while not done do
      done := processgrid(dir,prev,this);

    { Count the total number of energised grid squares }
    total := energised;
    { ... and save the highest score }
    if total > highscore then
    begin
      writeln ('New high score ',total,' from Northern firing at column ',x);
      highscore := total
    end
    else
      writeln ('Score ',total,' from Northern firing at column ',x)
  end;

  { West firings }
  writeln('');
  writeln('West ...');
  for x := 1 to idrow do
  begin
    nullbeamgrid;
    { Set the beam off to the west side of the grid }
    { for each row in the grid }
    prev.yy := idcol+1;
    prev.xx := x;
    this.yy := idcol;
    this.xx := x;
    { Set the direction of travel for the beam }
    dir := west;

    { And recursively process the beam(s) }
    done := processgrid(dir,prev,this);
    while not done do
      done := processgrid(dir,prev,this);

    { Count the total number of energised grid squares }
    total := energised;
    { ... and save the highest score }
    if total > highscore then
    begin
      writeln ('New high score ',total,' from Western firing at row ',x);
      highscore := total
    end
    else
       writeln ('Score ',total,' from Western firing at row ',x)
  end;

  { South firings }
  writeln('');
  writeln('South ...');
  for x := 1 to idcol do
  begin
    nullbeamgrid;
    { Set the beam off to the south side of the grid }
    { for each row in the grid }
    prev.yy := x;
    prev.xx := 0;
    this.yy := x;
    this.xx := 1;
    { Set the direction of travel for the beam }
    dir := south;

    { And recursively process the beam(s) }
    done := processgrid(dir,prev,this);
    while not done do
      done := processgrid(dir,prev,this);

    { Count the total number of energised grid squares }
    total := energised;
    { ... and save the highest score }
    if total > highscore then
    begin
      writeln ('New high score ',total,' from Southern firing at column ',x);
      highscore := total
    end
    else
      writeln ('Score ',total,' from Southern firing at column ',x);
  end;

  writeln('');
  writeln('Maximum grid squares energised = ',highscore)
end.
