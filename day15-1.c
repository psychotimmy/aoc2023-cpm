#include "STDIO.H"

hashme(str)
char *str;
{
  int i,current;

  current = 0;
  for (i=0; i<strlen(str); i++) {
    current = current + (int) str[i];
    current = current * 17;
    current = current % 256;
  }

  return(current);
}

main()
{
  FILE *fp;
  int ch, bidx;
  long total;
  char buf[80];

  printf("Advent of Code 2023 Day 15, part 1\n\n");

  total = 0;

  if ((fp = fopen("day15in.txt","r")) == NULL) {
    printf("day15in.txt not found\n");
    exit();
  }

  bidx = 0;
  /* Use agetc rather than getc as this is CP/M */
  while ((ch = agetc(fp)) != EOF) {
    if (ch == ',') {
      buf[bidx] = '\0';
      total = total + (long) hashme(buf);
      bidx = 0;
    }
    else
      buf[bidx++] = ch;
  }

  /* Deal with the last value to hash when EOF is reached */
  if (ch == EOF) {
    /* zap the newline and terminate the string */
    buf[bidx-1] = '\0';
    total = total + (long) hashme(buf);
  }

  printf("Sum of hash values is %ld\n",total);
}
