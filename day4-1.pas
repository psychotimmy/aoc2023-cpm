program day4p1(output);
const
  WINNING = 10;  { 5 for sample input, 10 for real puzzle input }
  LOTTONO = 25;  { 8 for sample input, 25 for real puzzle input }
type
  str2 = string[2];
  str160 = string[160];
var
  numfile : text;
  line: str160;
  win: array[1..WINNING] of str2;
  pick: array[1..LOTTONO] of str2;
  wins, card, cardno, w, p, total: integer;

procedure getwinners(ln: str160);
var i,j: integer;
begin
  j := pos(':',ln) + 2; { First number is 2 places after Card x: }
  for i := 1 to WINNING do
  begin
    win[i] :=  copy(ln,j,2);
    j := j+3
  end
end;

procedure getpicked(ln: str160);
var i,j: integer;
begin
  j := pos('|',ln) + 2; { First number is 2 places after separator | }
  for i := 1 to LOTTONO do
  begin
    pick[i] := copy(ln,j,2);
    j := j+3
  end
end;

function points(w: integer): integer;
var i, pt: integer;
begin
  if w = 0 then
    pt := 0
  else
    pt := 1;
  if w > 1 then
    for i := 2 to w do
      pt := pt * 2;

  points := pt  { Function return }
end;

begin
  writeln('Advent of Code 2023 Day 4, part 1');
  total := 0;
  cardno := 0;
  assign(numfile,'day4in.txt');
  reset(numfile);
  while not eof(numfile) do
  begin
    readln(numfile,line);
    cardno := cardno + 1;
    getwinners(line);
    getpicked(line);
    wins := 0;
    for p := 1 to LOTTONO do
      for w := 1 to WINNING do
        if pick[p] = win[w] then
          wins := wins + 1;
    card := points(wins);
    total := total + card
    {; writeln('Wins ',wins,' = points for card ',cardno,' is ',card,'. Running total is ',total) }
  end;
  close(numfile);
  writeln('');
  writeln('Total points value of cards is ',total)
end.
