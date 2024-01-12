program day1p1(output);
{$I BIGILIB.PAS}
var
  calfile: text;
  line: string[80];
  ans: string[2];
  idx, ansn, ierr: integer;
  ansb, total: BigInt;
begin
  writeln('Advent of Code 2023 Day 1, part 1');
  writeln(' ');
  assign(calfile,'day1in.txt');
  reset(calfile);
  total := '0';
  while not eof(calfile) do
  begin
    readln(calfile,line);
    { Get the left most digit }
    idx := 1;
    while not (line[idx] in ['0'..'9']) do
       idx := idx+1;
    ans := line[idx];
    { Get the right most digit }
    idx := length(line);
    while not (line[idx] in ['0'..'9']) do
       idx := idx-1;
    ans := ans+line[idx];

    { Convert string to number }
    val(ans,ansn,ierr);
    if ierr = 0 then
    begin
      str(ansn,ansb);
      total := add(total,ansb)
      { ;writeln('Calibration value is ',ansb,' running total is ',total) }
    end
    else
    begin
      writeln('Calibration value is ',ans,' !!!');
      writeln('Something went wrong !!!');
      halt
    end
  end;
  close(calfile);
  writeln (' ');
  writeln ('Sum of calibration values is ',total)
end.
