program day7p2(output);
{$I BIGILIB.PAS}
type
  str5 = string[5];
  str10 = string[10];
  str13 = string[13];
  hands = record
    hand : str5;
    valu : integer;
    strn : integer
  end;
const
  MAXHANDS = 1000;
  MAXINSAR = 250;  { Maximum size of insertion sort array }
  SUIT = 13;       { Number of cards in a suit }
  CARDS = 'J23456789TQKA';
var
  cardfile: text;
  newhand: str5;
  unsorted: array[1..MAXHANDS] of hands;
  sorted: array[1..MAXHANDS] of hands;
  line: str10;
  idx, points, max: integer;
  valub, idxb, maxb, total: BigInt;

procedure getcards(ln: str10; var hnd: str5; var pts: integer);
var j, k,ierr : integer;
    st : str5;
begin
  { Format is 5 cards, followed by space, followed by a value }
  hnd := '';
  for j := 1 to 5 do
    hnd := hnd + ln[j];
  j := 7;
  st :='';
  while j <= length(ln) do  { Last digit is at end of line }
  begin
    if ln[j] in ['0'..'9'] then
      st := st+ln[j];
    j := j+1
  end;
  val(st,k,ierr);
  if ierr = 0 then
    pts :=  k
  else
  begin
    writeln('Error in val ',st,':',k,':',ierr);
    halt
  end
end;

function handstrength(hnd: str5) : integer;
var hist: array[1..SUIT] of integer;
    i,j,idx: integer;
begin
  { Create a histogram of the hand }
  { Position 1 are jokers }
  for i := 1 to SUIT do
    hist[i] := 0;
  for i := 1 to 5 do
  begin
    idx := pos(hnd[i],CARDS);
    hist[idx] := hist[idx] + 1
  end;

  { Deal with jokers }
  case hist[1] of
    5: begin
         hist[2] := 5;
         hist[1] := 0
       end;
    4: begin
         for i := 2 to SUIT do
           if hist[i] = 1 then
           begin
             hist[i] := 5;
             hist[1] := 0;
           end
       end;
    3: begin
         for i := 2 to SUIT do
         begin
           if hist[i] = 2 then
           begin
             hist[i] := hist[i]+hist[1];
             hist[1] := 0
           end;
           if hist[i] = 1 then
           begin
             hist[i] := hist[i]+hist[1];
             hist[1] := 0
           end
         end
       end;
   2: begin
         for i := 2 to SUIT do
         begin
           if (hist[i] = 3) or (hist[i] = 2) then
           begin
             hist[i] := hist[i]+hist[1];
             hist[1] := 0
           end;
           if hist[i] = 1 then
           begin
             for j := i to SUIT do
               if hist[j] = 2 then
               begin
                 hist[j] := hist[j]+hist[1];
                 hist[1] := 0
               end;
             hist[i] := hist[i]+hist[1];
             hist[1] := 0
           end
         end
       end;
    1: begin
         for i := 2 to SUIT do
         begin
           if (hist[i] = 4) or (hist[i] = 3) or (hist[i] = 2) then
           begin
             hist[i] := hist[i]+hist[1];
             hist[1] := 0
           end;
           if (hist[i] = 1) then
           begin
             for j := i to SUIT do
               if (hist[j] = 2) or (hist[j] = 3) then
               begin
                 hist[j] := hist[j]+hist[1];
                 hist[1] := 0
               end;
             hist[i] := hist[i]+hist[1];
             hist[1] := 0
           end
         end
       end;
  end;

  { Use the histogram to calculate the hand type (strength) }
  handstrength := 1;    { If we don't find anything else, hand is a high card }
  for i := 2 to SUIT do
  begin
    if hist[i] = 2 then
    begin
      handstrength := 2;    { Assume a pair ... }
      for j := 2 to 13 do
      begin
        if (hist[j] = 2) and (j <> i) then { unless there's another pair, then two pair }
          handstrength := 3;
        if (hist[j] = 3) then { Unless we have a full house }
          handstrength := 5
      end
    end;
    if hist[i] = 3 then
    begin
      handstrength := 4;    { Assume three of a kind ... }
      for j := 2 to SUIT do
        if hist[j] = 2 then { unless there's a pair as well, then full house }
          handstrength := 5
    end;
    if hist[i] = 4 then
      handstrength := 6;    { Four of a kind }
    if hist[i] = 5 then
      handstrength := 7     { Five of a kind }
  end
end;

function readinput: integer;
var i: integer;
begin
  { Read the cards and values into a record }
  assign(cardfile,'day7in.txt');
  reset(cardfile);
  i := 0;
  while not eof(cardfile) do
  begin
    i := i+1;
    readln(cardfile,line);
    getcards(line,newhand,points);
    with unsorted[i] do
    begin
      hand := newhand;
      valu := points;
      strn := handstrength(newhand)
    end
  end;
  close(cardfile);
  readinput := i     { Function return }
end;

{ Returns true if hand1 ranks lower than hand 2 }
function rankhand(hand1:str5; hand2:str5): boolean;
var i: integer;
    low,test: boolean;
begin
  i := 1;
  low := false;
  test := true;
  while (i <= 5) and test do
  begin
    if (pos(hand1[i],CARDS) < pos(hand2[i],CARDS)) then
    begin
      low := true;
      test := false
    end;
    if (pos(hand1[i],CARDS) > pos(hand2[i],CARDS)) then
    begin
       low := false;
       test := false
    end;
    i := i+1
  end;
  rankhand := low { Function return }
end;

procedure sorthands(limit: integer);
var stg,tosort,i,j,k: integer;
    temp: array[1..MAXINSAR] of hands;
    temphand: hands;
begin
  { Sort by hand strength first }
  writeln('Sorting hands by strength');
  k := 1;
  for stg := 7 downto 1 do
    for i := 1 to limit do
      if unsorted[i].strn = stg then
      begin
        sorted[k] := unsorted[i];
        k := k+1
      end;
  { Insertion sort }
  for stg := 7 downto 1 do
  begin
    tosort := 0;
    for i := 1 to limit do
    begin
      if sorted[i].strn = stg then
      begin
        tosort := tosort+1;
        temp[tosort] := sorted[i]
      end
    end;
    { do sort }
    if tosort > 1 then
    begin
      for j := 2 to tosort do
      begin
        temphand := temp[j];
        k := j-1;
        while rankhand(temp[k].hand,temphand.hand) and (k>0) do
        begin
          temp[k+1] := temp[k];
          k := k-1
        end;
        temp[k+1] := temphand
      end
    end;
    writeln(' > ',tosort,' hands of strength ',stg,' sorted');
    { And put this section back into the sorted array }
    j := 1;
    for i := 1 to limit do
      if sorted[i].strn = stg then
      begin
        sorted[i] := temp[j];
        j := j+1
      end
  end
end;

begin
  writeln('Advent of Code 2023 Day 7, part 2');
  writeln('');

  max := readinput;

  writeln('Read ',max,' hands from input');
  writeln('');

  { Sort the hands }
  sorthands(max);

  writeln('All hands sorted');
  writeln('');
  writeln('Calculating winnings ...');

  { Calculate the total value }
  total := '0';
  max := max+1;
  str(max,maxb);
  for idx := 1 to max-1 do
  begin
    str(idx,idxb);
    str(sorted[idx].valu,valub);
    total := add(total,multiply(sub(maxb,idxb),valub));
    if (idx < (max-1)) and ((idx mod 50)=0) then
      writeln(' > Winnings from top ',idx,' hands are ',total)
  end;

  writeln('');
  writeln('Total winnings for ',max-1,' hands are ',total)
end.
