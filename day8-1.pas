program day8p1(output);
type
  str3 = string[3];
  str16 = string[16];
  node =
    record
      name : str3;
      left : str3;
      right : str3
    end;
var
  nodefile: text;
  line: str16;
  turns: array[1..280] of char;
  map: array[1..760] of node;
  thisnode: node;
  nextname: str3;
  total, numturns,idx, nptr: integer;
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
    map[id].name := copy(ln,1,3);
    map[id].left := copy(ln,8,3);
    map[id].right := copy(ln,13,3)
end;

begin
  writeln('Advent of Code 2023 Day 8, part 1');
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

  { Get AAA node to start }
  nptr := 1;
  while map[nptr].name <> 'AAA' do
    nptr := nptr+1;
  thisnode := map[nptr];

  { Go to the ZZZ node following the instructions }
  total := 0;
  while thisnode.name <> 'ZZZ' do
  begin
    direction := turns[(total mod numturns)+1];
    if direction = 'L' then
      nextname := thisnode.left
    else
      nextname := thisnode.right;
    nptr := 1;
    while map[nptr].name <> nextname do
      nptr := nptr+1;
    thisnode := map[nptr];
    total := total+1;
    if (total mod 500) = 0 then
      writeln(total,' steps taken so far')
  end;

  writeln ('');
  writeln ('Steps from AAA to ZZZ is ',total)
end.
