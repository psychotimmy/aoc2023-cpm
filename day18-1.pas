program day18p1(output);
{$I BIGILIB.PAS}
const
  MAXEDGES = 785;
type
  str2 = string[2];
  str24 = string[24];
  direction = (east,south,west,north);
  coords = record
    xx: integer;
    yy: integer
  end;
  { Part 1 doesn't use the edge colour }
  edges = record
    len: integer;
    dir: direction;
    vstart: coords;
    vend: coords
  end;
var
  edgefile: text;
  line: str24;
  i, idx, jdx: integer;
  px, py, tnum, sum1, sum2, area, perim, inside: BigInt;
  point1, point2: coords;
  edgelist: array [1..MAXEDGES] of edges;

procedure populateEdgeList(ln: str24; n: integer);
var ierr, dist: integer;
var st: str2;
var sp, fp: coords;

{ Get the edge starting co-ordinates }
begin
  if n=1 then
  begin
    sp.xx := 0;
    sp.yy := 0
  end
  else
    sp := edgelist[n-1].vend;

  { Get the edge length - 1 or 2 digits }
  st := ln[3];
  if ln[4] in ['0'..'9'] then
    st := st+ln[4];
  val(st,dist,ierr);

  if ierr=0 then
  begin
    case ln[1] of
      'U' : begin     { North }
              fp.xx := sp.xx-dist;
              fp.yy := sp.yy
            end;
      'D' : begin     { South }
              fp.xx := sp.xx+dist;
              fp.yy := sp.yy
            end;
      'R' : begin     { East }
              fp.xx := sp.xx;
              fp.yy := sp.yy+dist
            end;
      'L' : begin     { West }
              fp.xx := sp.xx;
              fp.yy := sp.yy-dist
            end
    end;
    { Update the new vertices in the list of edges }
    edgelist[n].vstart := sp;
    edgelist[n].vend := fp;
    edgelist[n].len := dist
  end
  else
  begin
    { Shouldn't get here }
    writeln('Error converting edge length');
    halt
  end
end;

begin
  writeln('Advent of Code 2023 Day 18, part 1');
  writeln ('');

  assign(edgefile,'day18in.txt');
  reset(edgefile);
  idx := 0;
  while not eof(edgefile) do
  begin
    idx := idx+1;
    readln(edgefile,line);
    populateEdgeList(line,idx)
  end;
  close(edgefile);

  writeln('Number of edges is ',idx);
  writeln('');

  perim := '0';
  for i := 1 to idx do
  begin
    str(edgelist[i].len,tnum);
    perim := add(perim,tnum)
  end;
  writeln ('Perimeter is ',perim);
  writeln('');

  area := '0';
  { Use the surveyor's formula (shoelace algortihm) to work out the area
    enclosed by the polygon. Need the start vertices only }
  sum1 := '0';
  sum2 := '0';
  for i := 1 to idx do
  begin
    if i = idx then
      jdx := 1
    else
      jdx := i+1;
    point1 := edgelist[i].vstart;
    point2 := edgelist[jdx].vstart;

    str(point1.xx,px);
    str(point2.yy,py);
    tnum := multiply(px,py);
    sum1 := add(sum1,tnum);

    str(point2.xx,px);
    str(point1.yy,py);
    tnum := multiply(px,py);
    sum2 := add(sum2,tnum)
  end;

  tnum := sub(sum1,sum2);
  area := divide(tnum,'2');

  if area[1]='-' then delete(area,1,1);  { Want the absolute value }

  writeln('Area enclosed by boundary is ',area);
  writeln('');

  { But we don't want the area, we want the number of grid squares inside
    the boundary. So use Pick's theorum Area = interior pts + all boundary points/2 - 1
    So interior pts = Area - all boundary points / 2 + 1  - in this case, the number
    of boundary points is the same as the length of the perimiter, perim. }

  tnum := divide(perim,'2');
  tnum := sub(area,tnum);
  inside := add(tnum,'1');

  writeln('Grid squares enclosed by boundary is ',add(perim,inside))
end.
