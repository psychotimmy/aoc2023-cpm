program day8p1(output);
type
  str3 = string[3];
  str16 = string[16];
  node =
    record
      name: str3;
      left: str3;
      right: str3;
      lno: integer;
      rno: integer
    end;
var
  nodefile: text;
  line: str16;
  turns: array[1..280] of char;
  map: array[1..750] of node;
  thisnode: node;
  total, numturns,idx: integer;
  direction: char;

procedure getturns(var len: integer);
var ch: char;
begin
  len := 0;
  read(nodefile,ch);
  while not eoln(nodefile) do
  begin
    len := len+1;
    turns[len] := ch;
    read(nodefile,ch)
  end;
  { At end of line so deal with last character }
  len := len+1;
  turns[len] := ch
end;

procedure addnode(ln:str16; id:integer);
begin
    if (id mod 150) = 0 then
      writeln('Adding map node ',id);
    map[id].name := copy(ln,1,3);
    map[id].left := copy(ln,8,3);
    map[id].right := copy(ln,13,3)
end;

procedure completemap(nt:integer);
var id, i: integer;
begin
  for id := 1 to nt do
  begin
    if (id mod 150) = 0 then
      writeln('Completing map node ',id);
    i := 1;
    while map[i].name <> map[id].left do
      i := i+1;
    map[id].lno := i;
    i := 1;
    while map[i].name <> map[id].right do
      i := i+1;
    map[id].rno := i
  end
end;

begin
  writeln('Advent of Code 2023 Day 8, part 1');
  writeln('');
  assign(nodefile,'day8in.txt');
  reset(nodefile);
  getturns(numturns); { Left / right turn sequence is first line of file }
  reset(nodefile);
  for idx := 1 to 2 do
    readln(nodefile,line);    { Reset file, skip first 2 lines }
  idx := 1;
  while not eof(nodefile) do  { Read in the node map }
  begin
    readln(nodefile,line);
    addnode(line,idx);
    idx := idx+1
  end;
  close(nodefile);

  { Complete the map to improve walk speed }
  writeln('');
  completemap(idx-1);

  { Get AAA node to start }
  writeln('');
  idx := 1;
  while map[idx].name <> 'AAA' do
    idx := idx+1;
  thisnode := map[idx];

  { Go to the ZZZ node following the instructions }
  total := 0;
  while thisnode.name <> 'ZZZ' do
  begin
    direction := turns[(total mod numturns)+1];
    if direction = 'L' then
      thisnode := map[thisnode.lno]
    else
      thisnode := map[thisnode.rno];
    total := total+1;
    if (total mod 1000) = 0 then
      writeln(total,' steps taken so far')
  end;

  writeln ('');
  writeln ('Steps from AAA to ZZZ is ',total)
end.
