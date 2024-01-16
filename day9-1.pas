program day9p1(output);
{$I BIGILIB.PAS}  { Set MAXLEN in BIGILIB.PAS to 25 to avoid memory issues }
const
  MAXVALUES = 25;
  MAXDEPTH = 22;
type
  str160 = string[160];
var
  numfile : text;
  line : str160;
  layer, i, j, cpos, idx, iseq : integer;
  seq : array[0..MAXDEPTH,1..MAXVALUES] of BigInt;
  exttotal, total : BigInt;

{ Return true if all elements in the calculated sequence are zero }
function diffzero(elements: integer; depth: integer): boolean;
var allzeros: boolean;
    k: integer;
begin
  allzeros := true;
  k := 1;
  while (k <= elements-1) do
  begin
    seq[depth+1,k] := sub(seq[depth,k+1],seq[depth,k]);
    if ne(seq[depth+1,k],'0') then
      allzeros := false;
    k := k+1
  end;
  diffzero := allzeros
end;

procedure getvals(ln: str160; var start: integer; var valu: BigInt);
var fp: integer;
begin
  fp := start;
  while ln[fp] <> ' ' do
    fp := fp+1;
  valu := copy(ln,start,fp-start);
  start := fp+1
end;

begin
  writeln('Advent of Code 2023 Day 9, part 1');
  assign(numfile,'day9in.txt');
  reset(numfile);
  total := '0';
  iseq := 0;
  while not eof(numfile) do
  begin
    readln(numfile,line);
    cpos := 1;                        { First number starts at column 1}
    idx := 0;
    iseq := iseq+1;
    writeln('Reading values for sequence ',iseq);
    while cpos <= length(line) do
    begin
      idx := idx+1;
      getvals(line,cpos,seq[0,idx]);  { Oasis values }
    end;

    writeln(' > calculating differences ...');
    layer := 0;                         { Differences }
    while not diffzero(idx,layer) do
    begin
      layer := layer+1;
      idx := idx-1
    end;
    writeln(' > ... became zero at layer ',layer);

    writeln(' > extrapolating');
    exttotal := '0';                    { Extrapolate }
    for i := layer downto 0 do
    begin
      exttotal := add(exttotal,seq[i,idx]);
      idx := idx+1
    end;

    total := add(total,exttotal);       { Sum }
    writeln(' > running total for extrapolations is ',total)
  end;

  close(numfile);
  writeln ('');
  writeln ('Sum of extrapolated values is ',total)
end.
