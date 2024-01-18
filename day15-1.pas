program day15p1(output);
{$I BIGILIB.PAS}
type
  str16 = string[16];
var
  hashfile: text;
  hashme: str16;
  hashval: integer;
  hashvalb, total: BigInt;

{ Compute hash value from string }
function hash(str:str16): integer;
var i,current: integer;
begin
  current := 0;
  for i := 1 to length(str) do
  begin
    current := current + ord(str[i]);
    current := current*17;
    current := current mod 256
  end;
  hash := current  { Function return }
end;

{ Read csv until end of line hit, retrun string }
function getstr: str16;
var hm: str16;
    ch: char;
begin
  hm := '';
  read(hashfile,ch);
  while (ch <> ',') and (not eoln(hashfile)) do
  begin
    hm := hm+ch;
    read(hashfile,ch)
  end;

  if eoln(hashfile) and (length(hm) > 0) then  { Deal with eoln hit }
    hm := hm+ch;
  getstr := hm  { Function return }
end;

begin
  writeln('Advent of Code 2023 Day 15, part 1');
  writeln('');

  assign(hashfile,'day15in.txt');
  reset(hashfile);
  total := '0';
  while not eof(hashfile) do
  begin
    hashme := getstr;
    if (hashme <> '') then
    begin
      hashval := hash(hashme);
      str(hashval,hashvalb);
      total := add(total,hashvalb)
    end
  end;
  close(hashfile);
  { Remove last has value as eoln hit }
  total := sub(total,hashvalb);
  writeln ('');
  writeln ('Sum of hash values is ',total)
end.
