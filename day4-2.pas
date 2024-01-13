program day4p2(output);
{$I BIGILIB.PAS}
const
  WINNING = 10;  { 5 for sample data, 10 for real puzzle input }
  LOTTONO = 25;  { 8 for sample data, 25 for real puzzle input }
  LINES = 213;   { 6 for sample data, 213 for real puzzle input }
  MATCHES = 1;
  COPIES = 2;
type
  str2 = string[2];
  str160 = string[160];
var
  numfile: text;
  line: str160;
  win: array[1..WINNING] of str2;
  pick: array[1..LOTTONO] of str2;
  cardcount, wins, w, p, cardno, i, ierr, kmatch: integer;
  winb, todo, total: BigInt;
  cardinfo: array[1..LINES,1..2] of BigInt;

procedure getwinners(ln: str160);
var i,j: integer;
begin
  j := pos(':',ln) + 2; { First number is 2 places after Card x: }
  for i := 1 to WINNING do
  begin
    win[i] := copy(ln,j,2);
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

begin
  writeln('Advent of Code 2023 Day 4, part 2');

  { Read all the cards, work out how many matches (wins) }
  { are on each card and store in cardinfo 2d array }

  assign(numfile,'day4in.txt');
  reset(numfile);
  cardno := 0;
  while not eof(numfile) do
  begin
    cardno := cardno + 1;
    readln(numfile,line);
    getwinners(line);
    getpicked(line);
    wins := 0;
    for p := 1 to LOTTONO do
      for w := 1 to WINNING do
        if pick[p] = win[w] then
          wins := wins + 1;
    str(wins,winb);
    cardinfo[cardno,MATCHES] := winb;
    cardinfo[cardno,COPIES] := '1'
  end;
  close(numfile);
  cardcount := cardno;

  writeln('Initial processing for ',cardcount,' cards completed.');

  { Work through each card to find out how many copies of subsequent cards are won }

  for cardno := 1 to cardcount do
  begin
    writeln('Perfoming additional processing for card ',cardno);
    todo := cardinfo[cardno,COPIES];
    writeln(todo,' copies to process');
    if gt(cardinfo[cardno,MATCHES],'0') then
    begin
      while gt(todo,'32000') do
      begin
        val(cardinfo[cardno,MATCHES],kmatch,ierr);
        for i := 1 to kmatch do
          if cardno + i <= cardcount then
            cardinfo[cardno+i,COPIES] := add(cardinfo[cardno+i,COPIES],'32000');
        todo := sub(todo,'32000')
      end;
      val(cardinfo[cardno,MATCHES],kmatch,ierr);
      for i := 1 to kmatch do
        if cardno + i <= cardcount then
          cardinfo[cardno+i,COPIES] := add(cardinfo[cardno+i,COPIES],todo)
    end
  end;

  total := '0';
  for cardno := 1 to cardcount do
    total := add(total,cardinfo[cardno,COPIES]);

  writeln('');
  writeln('Total number of scratchcards is ',total)
end.
