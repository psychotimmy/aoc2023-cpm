#include "STDIO.H"

#define ALLD 18
#define HALFD 9
#define ZERO 48
#define NOTFOUND -1

/* Globals */
char fwd[ALLD][6], bck[ALLD][6];

pos(substr,str)
char *substr, *str;
/* Returns the index of the first position that substr is in str */
/* Returns NOTFOUND (-1) if substr is not in str */
{
  int rpos, ipos, ssize, match;

  ssize = strlen(substr);

  /* If substr is longer than str return NOTFOUND (-1) */
  if (ssize > strlen(str)) return(-1);

  match = 0;
  ipos = 0;
  rpos = 0;

  while (str[rpos] != '\0') {

    while ((substr[ipos] == str[rpos+ipos]) && (substr[ipos] != '\0')) {
      match++;
      if (match == ssize) return(rpos); /* Substring found, return position */
      ipos++;
    }

    /* Substring not found - try again */
    rpos++;
    match = 0;
    ipos = 0;
  }

  /* If we get here, we've not found the substring */
  return(-1);
}

initfb()
{
  int i;

  for (i=0;i<HALFD;i++) {
    fwd[i][0] = (char) (ZERO+i+1);
    fwd[i][1] = '\0';
    strcpy(bck[i],fwd[i]);
  }

  strcpy(fwd[9],"one");
  strcpy(bck[9],"eno");
  strcpy(fwd[10],"two");
  strcpy(bck[10],"owt");
  strcpy(fwd[11],"three");
  strcpy(bck[11],"eerht");
  strcpy(fwd[12],"four");
  strcpy(bck[12],"ruof");
  strcpy(fwd[13],"five");
  strcpy(bck[13],"evif");
  strcpy(fwd[14],"six");
  strcpy(bck[14],"xis");
  strcpy(fwd[15],"seven");
  strcpy(bck[15],"neves");
  strcpy(fwd[16],"eight");
  strcpy(bck[16],"thgie");
  strcpy(fwd[17],"nine");
  strcpy(bck[17],"enin");
}

main()
{
  FILE *fp;
  char buf[80], rbuf[80];
  int i, llen, fdx, jdx, proc, spos, epos, anss, anse;
  long total;

  printf("Advent of Code 2023 Day 1, part 2\n\n");

  if ((fp = fopen("day1in.txt","r")) == NULL) {
    printf("day1in.txt not found\n");
    exit();
  }

  total = 0;
  proc = 0;

  initfb();

  while (fgets(buf,80,fp) != NULL) {

    buf[strlen(buf)-1] = '\0';  /* Ignore the CR */

    /* Reverse the buffer */
    llen = strlen(buf);
    for (i=0; i<llen; i++)
      rbuf[i] = buf[llen-i-1];
    rbuf[llen] = '\0';

    /* Save the buffer lengths - should be identical */
    spos = llen;
    epos = llen;
    jdx = 0;

    while (((spos > 0) || (epos > 0)) && (jdx < ALLD)) {
      if (spos > 0) {
        fdx = pos(fwd[jdx],buf);
        if (fdx != NOTFOUND) {
          if (fdx < spos) {
            spos = fdx;
            anss = jdx;
          }
        }
      }
      if (epos > 0) {
        fdx = pos(bck[jdx],rbuf);
        if (fdx != NOTFOUND) {
          if (fdx < epos) {
            epos = fdx;
            anse = jdx;
          }
        }
      }
      ++jdx;
    }

    if (anss >= HALFD)
      total = total + (long) ((anss-8)*10);
    else
      total = total + (long) ((anss+1)*10);

    if (anse >= HALFD)
      total = total + (long) (anse-8);
    else
      total = total + (long) (anse+1);

    if ((++proc % 100) == 0) printf("Running total after %d processed is %ld\n",proc,total);
  }

  fclose(fp);

  printf("\nSum of calibration values is %ld\n",total);
}
