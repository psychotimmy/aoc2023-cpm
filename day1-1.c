#include "STDIO.H"

main()
{
  FILE *fp;
  char buf[80];
  int jdx, proc;
  long total;

  printf("Advent of Code 2023 Day 1, part 1\n\n");
  
  if ((fp = fopen("day1in.txt","r")) == NULL) {
    printf("day1in.txt not found\n");
    exit();
  }

  total = 0;
  proc = 0;

  while (fgets(buf,80,fp) != NULL) {
    jdx = 0;
    while (((buf[jdx] < '1') || (buf[jdx] > '9')) && (buf[jdx] != NULL))
      ++jdx;

    total = total + (long) ((buf[jdx]-'0')*10);

    jdx = strlen(buf)-1;
    while (((buf[jdx] < '1') || (buf[jdx] > '9')) && (buf[jdx] != NULL))
      --jdx;

    total = total + (long) (buf[jdx]-'0');

    if ((++proc % 100) == 0) printf("Running total after %d processed is %ld\n",proc,total);    
  }

  fclose(fp);

  printf("\nSum of calibration values is %ld\n",total);
}  
  
